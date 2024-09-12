import {
  AfterViewInit,
  Component,
  ElementRef,
  HostListener,
  OnInit,
  ViewChild,
} from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';

import { Observable } from '@librairies/rxjs';
import { tap, map } from 'rxjs/operators';

import { IOrganism } from '../../shared/models/assessment.model';
import { ConfigService } from '../../shared/services/config.service';
import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';
import { ITask, PlanningDataSource } from './planning.datasource';

@Component({
  selector: 'cs-planning',
  templateUrl: './planning.component.html',
  styleUrls: ['./planning.component.scss']
})
export class PlanningComponent implements OnInit, AfterViewInit {

  filtersForm: FormGroup;
  baseApiEndpoint;
  firstLoad: Boolean = true;
  dataTableHeight: number;
  $organisms: Observable<IOrganism[]>;
  $progressStatus: Observable<any>;
  displayedColumns = [
    'type',
    'taxonName',
    'territoryName',
    'label',
    'progressStatus',
    'date',
    'actions',
  ];
  dataSource: PlanningDataSource;
  @ViewChild('dataTableContainer') dataTableContainer: ElementRef;
  @ViewChild(MatTable) dataTable: MatTable<ITask>;
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(
    private cfg: ConfigService,
    private dataService: DataService,
    private formBuilder: FormBuilder,
    public store: StoreService,
  ) { }

  ngOnInit() {
    // WARNING: respect order of methods call
    this.initializeDataSource();
    this.initializePlanningFiltersForm();
    this.loadOrganisms();
    this.loadCurrentUserOrganismId();
    this.loadTasks();
    this.loadProgressStatus();

    // WARNING: use Promise to avoid ExpressionChangedAfterItHasBeenCheckedError
    // See: https://angular.io/errors/NG0100
    Promise.resolve(null).then(() => this.recalculateDataTableSize());
  }

  ngAfterViewInit(): void {
    // Reset the paginator after sorting
    this.sort.sortChange.subscribe(() => this.paginator.firstPage());

    this.paginator.page
      .pipe(
        tap(() => {
          this.dataSource.setFilterParam('limit', this.paginator.pageSize.toString());
          this.dataSource.setFilterParam('page', this.paginator.pageIndex.toString());
          this.loadTasks();
        })
      )
      .subscribe();

    this.sort.sortChange
      .pipe(
        tap((event) => {
          this.dataSource.setFilterParam('sort', `${event.active}:${event.direction}`);
          this.loadTasks();
        })
      ).subscribe();
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
    const screenHeight = document.documentElement.clientHeight;
    const dataTableTop = this.dataTableContainer.nativeElement.getBoundingClientRect().top;
    // TODO: see why we need to remove 11px !
    const dataTableHeight = screenHeight - dataTableTop - 11;
    this.dataTableHeight = dataTableHeight;
  }

  private initializeDataSource() {
    this.dataSource = new PlanningDataSource(this.dataService);
  }

  detectTypeOfTask(task) {
    let url = [
      '/conservation_strategy',
      'priority-taxa',
      task.priorityTaxonId,
      'assessments',
      task.assessmentId
    ];
    if (task.actionId) {
      url.push('actions', task.actionId);
    }
    return url;
  }

  private initializePlanningFiltersForm() {
    this.baseApiEndpoint = this.cfg.getModuleBackendUrl();
    this.filtersForm = this.formBuilder.group({
      organismFilter: null,
      taskFilter: null,
      statusFilter: null,
    });
  }

  private loadCurrentUserOrganismId() {
    let currentUser = localStorage.getItem('gn_current_user');
    let currentUserJson = JSON.parse(currentUser);
    this.filtersForm.controls['organismFilter'].patchValue([currentUserJson.id_organisme])
    this.dataSource.setFilterParam('organisms', currentUserJson.id_organisme);
  }

  onTaskTypeFilterChanged(event) {
    this.dataSource.setFilterParam('type', event.value);
    this.loadTasks();
  }

  onTaskTypeFilterCleared(event) {
    event.stopPropagation();
    this.filtersForm.controls.taskFilter.reset();
    this.dataSource.removeFilterParam('type');
    this.loadTasks();
  }

  onStatusFilterChanged(event) {
    this.dataSource.setFilterParam('progress-status', event.value);
    this.loadTasks();
  }

  onStatusFilterCleared(event) {
    event.stopPropagation();
    this.filtersForm.controls.statusFilter.reset();
    this.dataSource.removeFilterParam('progress-status');
    this.loadTasks();
  }

  loadTasks() {
    this.dataSource.loadTasks();
    if (this.firstLoad) {
      this.calculateDataTableHeight();
      this.firstLoad = false;
    }
  }

  loadOrganisms() {
    this.$organisms = this.dataService.getOrganisms().pipe(
      map(organisms => {
        let organismList = [];
        organisms.forEach((item) => {
          organismList.push(item);
        })
        return organismList;
      })
    );
  }

  onOrganismChanged(event) {
    let organismIds = event.value;
    if (organismIds && organismIds.length > 0) {
      this.dataSource.setFilterParam('organisms', organismIds.join(','));
    } else {
      this.dataSource.removeFilterParam('organisms');
    }
    this.loadTasks();
  }

  loadProgressStatus() {
    this.$progressStatus = this.dataService.getNomenclatures('CS_ACTION_PROGRESS').pipe(
      map(nomenclatures => {
        let nomenclaturesList = [];
        nomenclatures.values.forEach((item) => {
          nomenclaturesList.push({ code: item.cd_nomenclature, label: item.label_default });
        })
        return nomenclaturesList;
      })
    );
  }

}
