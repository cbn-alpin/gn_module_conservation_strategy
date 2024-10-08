import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';

import { Observable, Subscription } from '@librairies/rxjs';

import { Assessment, IAssessmentList } from '../../shared/models/assessment.model';
import { AssessmentForm } from './assessment-form/assessment-form.component';
import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';


@Component({
  selector: 'cs-assessments-list',
  templateUrl: './assessments-list.component.html',
  styleUrls: ['./assessments-list.component.scss']
})
export class AssessmentsListComponent implements OnInit, OnDestroy {

  assessments: Observable<IAssessmentList>;
  activatedRouteSubscription: Subscription;
  assessmentIdSelected: number;
  actionIdSelected: number;
  goingToNewAssessment: boolean;
  goingToNewAction: boolean;

  constructor(
    private dataService: DataService,
    private dialog: MatDialog,
    private store: StoreService,
    public route: ActivatedRoute,
    private router: Router,
  ) { }

  ngOnInit() {
    this.loadAssessments();
    this.extractRouteParams();
  }

  private extractRouteParams() {
    this.activatedRouteSubscription = this.route.paramMap.subscribe(urlParams => {
      if (urlParams.has('assessmentId')) {
        this.assessmentIdSelected = +urlParams.get('assessmentId');
        this.goingToNewAssessment = false;
      }
      if (urlParams.has('actionId')) {
        this.actionIdSelected = +urlParams.get('actionId');
        this.goingToNewAction = false;
      }
    });
  }


  ngOnDestroy(): void {
    this.activatedRouteSubscription.unsubscribe();
  }

  private loadAssessments() {
    const params = {
      'priority-taxon-id': this.store.priorityTaxon,
    }
    this.assessments = this.dataService.getAssessments(params);
  }

  goToAssessment(id) {
    // Prevent for looping twice because of expanded
    if (!this.assessmentIdSelected || this.assessmentIdSelected !== id) {
      this.goingToNewAssessment = true;
      let url = this.router.url.replace(/assessments\/.+$/, 'assessments');
      this.router.navigateByUrl(decodeURIComponent(url) + '/' + id);
    }
  }

  resetAssessmentList(id) {
    if (!this.goingToNewAssessment && this.assessmentIdSelected == id) {
      let url = this.router.url.replace(/assessments\/[0-9]+$/, 'assessments');
      this.router.navigateByUrl(decodeURIComponent(url));
    }
  }


  openAssessmentEditModal(assessment = new Assessment()): void {
    const dialogRef = this.dialog.open(AssessmentForm, {
      data: {
        'assessment': assessment,
      },
      disableClose: true,
      panelClass: 'edit-assessment-modal',
      width: '80vw',
      maxWidth: '1200px',
      maxHeight: '80vh',
    });

    dialogRef.afterClosed().subscribe(msg => {
      if (msg == 'OK') {
        this.loadAssessments();
      }
    });
  }
}
