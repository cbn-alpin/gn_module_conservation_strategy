import {
  AfterViewInit,
  AfterViewChecked,
  Component,
  ElementRef,
  HostListener,
  OnInit,
  ViewChild,
  OnDestroy,
} from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { MatPaginator, MatSort, MatTable } from '@angular/material';
import { Subscription } from '@librairies/rxjs';

import { tap } from 'rxjs/operators';

import { ConfigService } from '../../shared/services/config.service';
import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';
import { PriorityTaxa, TaxaDataSource } from './taxa.datasource';

@Component({
  selector: 'cs-taxa-list',
  templateUrl: './taxa-list.component.html',
  styleUrls: ['./taxa-list.component.scss']
})
export class CsTaxaListComponent implements OnInit, OnDestroy, AfterViewInit, AfterViewChecked {

  filtersForm: FormGroup;
  baseApiEndpoint;
  firstLoad: Boolean = true;
  dataTableHeight: number;
  displayedColumns = [
    'fullName',
    'cpi',
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
  territorySubcription: Subscription;

  constructor(
    private cfg: ConfigService,
    private dataService: DataService,
    private formBuilder: FormBuilder,
    public store: StoreService,
  ) {}

  ngOnInit() {
    this.initializeDataSource();
    this.initializeTaxaFiltersForm();
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
  }

  ngAfterViewChecked(): void {
    if (this.dataTableHeight == undefined) {
      this.calculateDataTableHeight();
    }
  }

  ngOnDestroy(): void {
    this.territorySubcription.unsubscribe();
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
    this.onTerritoryChange();
  }

  private onTerritoryChange() {
    this.territorySubcription = this.store.getSelectedTerritoryStatus.subscribe((status) => {
      if (status === true) {
        this.paginator.firstPage();
        this.loadTaxa();
      }
    });
  }

  private initializeTaxaFiltersForm() {
    this.baseApiEndpoint = this.cfg.getModuleBackendUrl();
    this.filtersForm = this.formBuilder.group({
      taxaFilter: null,
      cpiFilter: null,
      assessmentFilter: null,
    });
  }

  onTaxonFilterChanged(taxonName) {
    this.dataSource.setFilterParam('cd-nom', taxonName.cdNom);
    this.loadTaxa();
  }

  onTaxonFilterDeleted(taxonName) {
    this.dataSource.removeFilterParam('cd-nom');
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
}
