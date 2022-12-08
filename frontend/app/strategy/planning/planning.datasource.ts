import { DataSource, CollectionViewer } from '@angular/cdk/collections';
import { HttpParams } from "@angular/common/http";

import { Observable, of } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { catchError, finalize } from 'rxjs/operators'

import { DataService } from '../../shared/services/data.service';

export interface ITask {
    taskType: string;
    taxonName: string;
    territory: string;
    toDo?: string;
    progressStatus: string;
    taskDate: number;
    actions: string;
}

export interface ITasks {
  totalCount: number;
  incompleteResults: boolean;
  items: ITask[];
}

export class PlanningDataSource implements DataSource<ITask> {

  private taskSubject = new BehaviorSubject<ITask[]>([]);
  private loadingSubject = new BehaviorSubject<boolean>(false);
  private itemsCountSubject = new BehaviorSubject<number>(0);
  public loading$ = this.loadingSubject.asObservable();
  public itemsCount$ = this.itemsCountSubject.asObservable();
  public filtersQueryString: HttpParams;

  constructor(private dataService: DataService) {
    this.filtersQueryString = new HttpParams();
  }

  connect(collectionViewer: CollectionViewer): Observable<ITask[]> {
    return this.taskSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
      this.taskSubject.complete();
      this.loadingSubject.complete();
  }

  setFilterParam(param: string, value: string): void {
    this.filtersQueryString = this.filtersQueryString.set(param, value);
  }

  removeFilterParam(param: string): void {
    this.filtersQueryString = this.filtersQueryString.delete(param);
  }

  loadTasks(): void {
    this.loadingSubject.next(true);

    this.dataService.getTasks()
      .pipe(
        catchError(() => of([])),
        finalize(() => this.loadingSubject.next(false))
      )
      .subscribe(task => {
        this.taskSubject.next(task["items"]);
        this.itemsCountSubject.next(task["totalCount"]);
      });
  }
}
