import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';

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

  @Input() assessmentId: number;
  @Input() actionIdSelected: number;
  assessmentDetail!: Observable<Assessment>;
  @Input() goingToNewAction: boolean;

  constructor(
    public dataService: DataService,
    public storeService: StoreService,
    public router: Router,
    public location: Location,
  ) { }

  ngOnInit() {
    this.assessmentDetail = this.dataService.getAssessment(this.assessmentId);
  }

  goToAction(id) {
    // Prevent for looping twice because of expanded
    if (!this.actionIdSelected || this.actionIdSelected !== id) {
      this.goingToNewAction = true;
      let url = this.router.url.replace(/\/actions\/[0-9]+$/, '');
      this.router.navigateByUrl(decodeURIComponent(url) + '/actions/' + id);
    }
  }

  resetActionList(id) {
    if (!this.goingToNewAction && this.actionIdSelected == id) {
      let url = this.router.url.replace(/\/actions\/[0-9]+$/, '');
      this.router.navigateByUrl(decodeURIComponent(url));
    }
    this.goingToNewAction = false;
  }
}
