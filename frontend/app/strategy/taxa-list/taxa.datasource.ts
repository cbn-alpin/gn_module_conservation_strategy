import { DataSource, CollectionViewer } from '@angular/cdk/collections';
import { HttpParams } from "@angular/common/http";

import { Observable, of } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { catchError, finalize } from 'rxjs/operators'

import { DataService } from '../../shared/services/data.service';

export interface PriorityTaxa {
  refNameCode: number;
  fullName: string;
  displayFullName: string;
  shortName: string;
  nameCode: number;
  revisedCpi?: number;
  computedCpi?: number;
  dateMin?: string;
  dateMax?: string;
  assessmentCount?: number;
}

export class TaxaDataSource implements DataSource<PriorityTaxa> {

  private taxaSubject = new BehaviorSubject<PriorityTaxa[]>([]);
  private loadingSubject = new BehaviorSubject<boolean>(false);
  private itemsCountSubject = new BehaviorSubject<number>(0);
  public loading$ = this.loadingSubject.asObservable();
  public itemsCount$ = this.itemsCountSubject.asObservable();
  public filtersQueryString: HttpParams;

  constructor(private dataService: DataService) {
    this.filtersQueryString = new HttpParams();
  }

  connect(collectionViewer: CollectionViewer): Observable<PriorityTaxa[]> {
    return this.taxaSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
      this.taxaSubject.complete();
      this.loadingSubject.complete();
  }

  setFilterParam(param: string, value: string): void {
    this.filtersQueryString = this.filtersQueryString.set(param, value);
  }

  removeFilterParam(param: string): void {
    this.filtersQueryString = this.filtersQueryString.delete(param);
  }

  loadTaxa(): void {
    this.loadingSubject.next(true);

    this.dataService.getPriorityTaxa(this.filtersQueryString)
      .pipe(
        catchError(() => of([])),
        finalize(() => this.loadingSubject.next(false))
      )
      .subscribe(taxa => {
        this.taxaSubject.next(taxa.items);
        this.itemsCountSubject.next(taxa.totalCount);
      });
  }
}
