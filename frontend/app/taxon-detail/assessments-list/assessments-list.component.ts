import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material';
import { ActivatedRoute } from '@angular/router';
import { Observable, Subscription } from '@librairies/rxjs';


import { Assessment, IAssessmentList } from '../../shared/models/assessment.model';
import { AssessmentForm } from './assessment-form/assessment-form.component';
import { ConfigService } from '../../shared/services/config.service';
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

  constructor(
    private dataService: DataService,
    private dialog: MatDialog,
    private store: StoreService,
  ) {}

  ngOnInit() {
    this.territorySubcription = this.store.getSelectedTerritoryStatus.subscribe((status) => {
      if (status) {
        this.loadAssessments();
      }
    });
  }

  ngOnDestroy(): void {
    this.territorySubcription.unsubscribe();
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
