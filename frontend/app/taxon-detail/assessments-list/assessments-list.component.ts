import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material';
import { ActivatedRoute } from '@angular/router';
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
export class CsAssessmentsListComponent implements OnInit, OnDestroy {

  assessments: Observable<IAssessmentList>;
  territorySubcription: Subscription;
  activatedRouteSubscription: Subscription;
  assessmentIdSelected: number;

  constructor(
    private dataService: DataService,
    private dialog: MatDialog,
    private store: StoreService,
    public route: ActivatedRoute,
  ) {}

  ngOnInit() {
    this.territorySubcription = this.store.getSelectedTerritoryStatus.subscribe((status) => {
      if (status) {
        this.loadAssessments();
      }
    });
    this.extractRouteParams();
    //observable pour récupérer l'id de l'assessment. stocker dans variable
  }

  private extractRouteParams() {
    this.activatedRouteSubscription = this.route.paramMap.subscribe(urlParams => {
      if (urlParams.has('assessmentId')) {
        this.assessmentIdSelected = +urlParams.get('assessmentId');
      }
    });
  }

  ngOnDestroy(): void {
    this.territorySubcription.unsubscribe();
    this.activatedRouteSubscription.unsubscribe();
  }

  private loadAssessments() {
    const params = {
      'territory-code': this.store.selectedTerritory.code.toLowerCase(),
      'priority-taxon-id': this.store.selectedTaxon,
    }
    this.assessments = this.dataService.getAssessments(params);
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
