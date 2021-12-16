import { Component, Input, OnInit } from '@angular/core';

import { map } from 'rxjs/operators';
import { Observable } from 'rxjs/internal/Observable';

import { Assessment } from '../../../shared/models/assessment.model';
import { DataService } from '../../../shared/services/data.service';
import { StoreService } from '../../../shared/services/store.service';

@Component({
  selector: 'cs-assessment-detail',
  templateUrl: './assessment-detail.component.html',
  styleUrls: ['./assessment-detail.component.scss']
})
export class AssessmentDetailComponent implements OnInit {
  /** Identifiant du rapport de bilan stationel. */
  @Input() assessmentId: number;
  assessmentDetail!: Observable<Assessment>;

  constructor(
    public dataService: DataService,
    public storeService: StoreService,
  ) {}

  ngOnInit() {
    this.assessmentDetail = this.dataService.getAssessment(this.assessmentId);
  }
}
