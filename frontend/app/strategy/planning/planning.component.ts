import {
  AfterViewInit,
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
import { ITask, PlanningDataSource } from './planning.datasource';

@Component({
  selector: 'cs-planning',
  templateUrl: './planning.component.html',
  styleUrls: ['./planning.component.scss']
})
export class CsPlanningComponent implements OnInit, AfterViewInit {

  filtersForm: FormGroup;
  baseApiEndpoint;
  firstLoad: Boolean = true;
  dataTableHeight: number;
  displayedColumns = [
    'taskType',
    'taxonName',
    'territoryName',
    'taskLabel',
    'progressStatus',
    'taskDate',
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
    this.initializeDataSource();
    this.initializePlanningFiltersForm();
    this.loadTasks();

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
      )
      .subscribe();
    
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
        this.paginator.firstPage();
  }

  private initializePlanningFiltersForm() {
    this.baseApiEndpoint = this.cfg.getModuleBackendUrl();
    this.filtersForm = this.formBuilder.group({
      organismFilter: null, //organisme de l'utilisateur connecté
      taskFilter: null,
      progressFilter: null,
    });
  }

  onTaskFilterChanged(event) {
    if (event.checked) {
      this.dataSource.setFilterParam('with-task', 'true');
    } else {
      this.dataSource.removeFilterParam('with-task');
    }
    this.loadTasks();
  }

  onProgressFilterChanged(event) {
    if (event.checked) {
      this.dataSource.setFilterParam('with-progress', 'true');
    } else {
      this.dataSource.removeFilterParam('with-progress');
    }
    this.loadTasks();
  }

  loadTasks() {
    this.dataSource.loadTasks();
    if (this.firstLoad) {
      this.calculateDataTableHeight();
      this.firstLoad = false;
    }
  }

}
