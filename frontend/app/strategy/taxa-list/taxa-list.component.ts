import {
  AfterViewInit,
  Component,
  ElementRef,
  HostListener,
  OnInit,
  ViewChild,
} from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { MatPaginator, MatSort, MatTable } from '@angular/material';

import { Observable } from '@librairies/rxjs';
import { tap, map } from 'rxjs/operators';

import { ConfigService } from '../../shared/services/config.service';
import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';
import { PriorityTaxa, TaxaDataSource } from './taxa.datasource';
import { ITerritory } from "../../shared/models/assessment.model";

@Component({
  selector: 'cs-taxa-list',
  templateUrl: './taxa-list.component.html',
  styleUrls: ['./taxa-list.component.scss']
})
export class TaxaListComponent implements OnInit, AfterViewInit {

  filtersForm: FormGroup;
  baseApiEndpoint;
  firstLoad: Boolean = true;
  dataTableHeight: number;
  $territories: Observable<ITerritory[]>;
  displayedColumns = [
    'fullName',
    'cpi',
    'territoryName',
    'dateMin',
    'dateMax',
    'areaPresenceCount',
    'assessmentCount',
    'actions',
  ];
  dataSource: TaxaDataSource;
  @ViewChild('dataTableContainer') dataTableContainer: ElementRef;
  @ViewChild(MatTable) dataTable: MatTable<PriorityTaxa>;
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(
    private cfg: ConfigService,
    private dataService: DataService,
    private formBuilder: FormBuilder,
    public store: StoreService,
  ) {}

  ngOnInit() {
    this.initializeDataSource();
    this.initializeTaxaFiltersForm();
    this.loadTerritories();
    this.loadTaxa();
  }

  ngAfterViewInit(): void {
    // Reset the paginator after sorting
    this.sort.sortChange.subscribe(() => this.paginator.firstPage());

    this.paginator.page
      .pipe(
        tap(() => {
          this.dataSource.setFilterParam('limit', this.paginator.pageSize.toString());
          this.dataSource.setFilterParam('page', this.paginator.pageIndex.toString());
          this.loadTaxa();
        })
      )
      .subscribe();

    this.sort.sortChange
      .pipe(
          tap((event) => {
            this.dataSource.setFilterParam('sort', `${event.active}:${event.direction}`);
            this.loadTaxa();
          })
      )
      .subscribe();
    
    // WARNING: use Promise to avoid ExpressionChangedAfterItHasBeenCheckedError
    // See: https://angular.io/errors/NG0100
    Promise.resolve(null).then(() => this.recalculateDataTableSize());
  }

  private recalculateDataTableSize(): void {
    if (this.dataTableHeight == undefined) {
      this.calculateDataTableHeight();
    }
  }

  @HostListener("window:resize", ["$event"])
  onWindowResize(event) {
    this.calculateDataTableHeight();
  }

  private calculateDataTableHeight(): void {
    const screenHeight: number = document.documentElement.clientHeight;
    const dataTableTop = this.dataTableContainer.nativeElement.getBoundingClientRect().top;
    // TODO: see why we need to remove 11px !
    const dataTableHeight = screenHeight - dataTableTop - 11 ;
    this.dataTableHeight = dataTableHeight;
  }

  private initializeDataSource() {
    this.dataSource = new TaxaDataSource(this.dataService);
  }

  private initializeTaxaFiltersForm() {
    this.baseApiEndpoint = this.cfg.getModuleBackendUrl();
    this.filtersForm = this.formBuilder.group({
      taxaFilter: null,
      cpiFilter: null,
      territoryFilter: null,
      assessmentFilter: null,
    });
  }

  onTaxonFilterChanged(taxonName) {
    this.dataSource.setFilterParam('taxon-name-code', taxonName.cdNom);
    this.loadTaxa();
  }

  onTaxonFilterDeleted(taxonName) {
    this.dataSource.removeFilterParam('taxon-name-code');
    this.loadTaxa();
  }

  onCpiFilterChanged(event) {
    this.dataSource.setFilterParam('cpi', event.value);
    this.loadTaxa();
  }

  onCpiFilterCleared(event) {
    event.stopPropagation();
    this.filtersForm.controls.cpiFilter.reset();
    this.dataSource.removeFilterParam('cpi');
    this.loadTaxa();
  }

  onTerritoryFilterChanged(territory) {
    this.dataSource.setFilterParam('territory-code', territory.value);
    this.loadTaxa();
  }

  onTerritoryFilterCleared(event) {
    event.stopPropagation();
    this.filtersForm.controls.territoryFilter.reset();
    this.dataSource.removeFilterParam('territory-code');
    this.loadTaxa();
  }

  onAssessmentFilterChanged(event) {
    if (event.checked) {
      this.dataSource.setFilterParam('with-assessment', 'true');
    } else {
      this.dataSource.removeFilterParam('with-assessment');
    }
    this.loadTaxa();
  }

  loadTaxa() {
    this.dataSource.loadTaxa();
    if (this.firstLoad) {
      this.calculateDataTableHeight();
      this.firstLoad = false;
    }
  }

  loadTerritories() {
    this.$territories = this.dataService.getTerritories().pipe(
      map(territories => {
        let territoriesList = [];
        territories.forEach((item) => {
          territoriesList.push({ code: item.code, label: item.label });
        })
        return territoriesList;
      })
    );
  }

}
