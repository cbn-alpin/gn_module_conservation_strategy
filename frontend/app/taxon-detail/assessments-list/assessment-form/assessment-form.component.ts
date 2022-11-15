import { AfterViewInit, Component, ComponentFactoryResolver, ComponentRef, Inject, OnInit, ViewChild, ViewContainerRef } from "@angular/core";
import { FormArray, FormBuilder, FormGroup, FormControl } from "@angular/forms";
import { MatDialogRef, MAT_DIALOG_DATA } from "@angular/material";
import { ActivatedRoute, ActivatedRouteSnapshot, Router } from "@angular/router";

import { BehaviorSubject } from "@librairies/rxjs";

import { CommonService } from "@geonature_common/service/common.service";

import { DialogService } from "../../../shared/components/confirm-dialog/confirm-dialog.service";
import { Action, Assessment, IAction, IAssessment } from "../../../shared/models/assessment.model";
import { DataService } from "../../../shared/services/data.service";
import { ActionForm } from "./action-form/action-form.component";

@Component({
  selector: 'cs-assessment-form',
  templateUrl: './assessment-form.component.html',
  styleUrls: ['./assessment-form.component.scss'],
})
export class AssessmentForm implements OnInit, AfterViewInit {


  @ViewChild('actionsFormContainer', { read: ViewContainerRef })
  actionsContainer: ViewContainerRef;
  actionsForms: ComponentRef<ActionForm>[] = [];
  assessment: Partial<IAssessment> = new Assessment();
  currentYear: number;
  form!: FormGroup;
  updateMode: BehaviorSubject<boolean> = new BehaviorSubject(false);
  territoryCode: any;
  priorityTaxonId: number;

  constructor(
    public activatedRoute: ActivatedRoute,
    private commonService: CommonService,
    private componentFactoryResolver: ComponentFactoryResolver,
    @Inject(MAT_DIALOG_DATA)
    public data: any,
    private dialogService: DialogService,
    private dataService: DataService,
    private formBuilder: FormBuilder,
    public modalRef: MatDialogRef<AssessmentForm>,
    private router: Router,
  ) {
    if (data.assessment.id) {
      this.assessment.id = data.assessment.id;
    }
    this.currentYear = (new Date()).getFullYear();
  }

  get actions() {
    return this.form.get('actions') as FormArray;
  }

  ngOnInit(): void {
    this.extractRouteParams();
    this.checkMode();
    this.initializeFormGroups();
  }

  private extractRouteParams() {
    const urlParams = this.collectRouteParams();
    this.territoryCode = urlParams['territoryCode'];
    this.priorityTaxonId = parseInt(urlParams["priorityTaxonId"]);
  }

  private collectRouteParams() {
    let params = {};
    let stack: ActivatedRouteSnapshot[] = [this.router.routerState.snapshot.root];
    while (stack.length > 0) {
      const route = stack.pop()!;
      params = {...params, ...route.params};
      stack.push(...route.children);
    }
    return params;
  }

  private checkMode(): void {
    if (this.assessment.id) {
      this.dataService
        .getAssessment(this.assessment.id)
        .subscribe(assessment => {
          this.assessment = assessment;
          this.initializeFormGroups();
          this.updateMode.next(true);
        });
    } else {
      this.updateMode.next(false);
    }
  }

  private initializeFormGroups(): void {
    this.form = this.formBuilder.group({
      assessment: this.formBuilder.group({
        assessmentDate: new FormControl(new Date()),
        threats: [this.assessment.threats, null],
        description: [this.assessment.description, null],
        nextAssessmentYear: [this.assessment.nextAssessmentYear, null],
      }),
      actions: this.formBuilder.array([]),
    });
    if (this.assessment.actions) {
      this.assessment.actions.map(action => this.addActionForm(action))
    }
  }

  ngAfterViewInit(): void {
    this.actionsContainer.clear();
  }

  onNextAssessmentYearSliderChange(event) {
    this.form.get('assessment.nextAssessmentYear').setValue(event.value);
  }

  onAddActionForm() {
    this.addActionForm();
  }

  private addActionForm(action: Partial<IAction> = new Action()): void {
    let newActionGroup = this.createActionFormGroup(action);
    const actionUuid = newActionGroup.get('uuid').value;
    let actionsGroup = this.form.get('actions') as FormArray;
    actionsGroup.push(newActionGroup);

    const componentFactory = this.componentFactoryResolver.resolveComponentFactory(ActionForm);
    const actionFormRef = this.actionsContainer.createComponent(componentFactory);
    this.actionsForms.push(actionFormRef);

    const actionFormComponent = <ActionForm>actionFormRef.instance;
    actionFormComponent.uuid = actionUuid;
    actionFormComponent.actionNumber = actionsGroup.length;
    actionFormComponent.parentFormGroup = newActionGroup;
    actionFormComponent.action = action;
    actionFormComponent.deleted.subscribe((uuid) => {
      let actionsGroup = this.form.get('actions') as FormArray;
      actionsGroup.removeAt(actionsGroup.value.findIndex(action => action.uuid === uuid));

      const index = this.actionsForms.findIndex(actionForm => actionForm.instance.uuid === uuid);
      this.actionsForms[index].destroy();
      this.actionsForms.splice(index, 1);
    });
  }

  private createActionFormGroup(action: Partial<IAction>): FormGroup {
    return this.formBuilder.group({
      id: [action.id],
      uuid: [action.uuid],
      level: [action.levelCode],
      type: [action.typeCode],
      progress: [action.progressCode],
      planFor: [action.planFor],
      startingDate: [action.startingDate],
      implementationDate: [action.implementationDate],
      description: [action.description],
      partners: [action.partners.map(partner => partner.uuid)],
    });
  }

  onResetForm() {
    this.dialogService
      .confirmDialog({
        message: 'Étes vous certain de vouloir réinitialiser le formulaire (perte des données) ?'
      })
      .subscribe((yes) => {
        if (yes) {
          this.form.reset();
          this.actionsContainer.clear();
        }
      });
  }

  onCloseForm() {
    this.dialogService
      .confirmDialog({
        message: 'Étes vous certain de vouloir fermer le formulaire (perte des données) ?'
      })
      .subscribe((yes) => {
        if (yes) {
          this.modalRef.close('CANCEL');
        }
      });
  }

  onCreateAssessment() {
    const assessmentData = this.getAssessmentData();

    this.dataService
      .addAssessment(assessmentData)
      .subscribe(
        () => {
          this.commonService.regularToaster('info', 'Fiche bilan enregistré');
          this.modalRef.close('OK');
        },
        error => {
          const msg = (error.error && error.error.msg)
            ? error.error.msg
            : error.message;
          console.log(msg);
          this.commonService.regularToaster(
            'error',
            'Bilan non enregistré. Une erreur est survenue sur le serveur.'
          );
        }
      );
  }

  onUpdateAssessment() {
    const assessmentData = this.getAssessmentData();

    this.dataService
      .updateAssessment(assessmentData)
      .subscribe(
        () => {
          this.commonService.regularToaster('info', 'Fiche bilan mise à jour');
          this.modalRef.close('OK');
        },
        error => {
          const msg = (error.error && error.error.msg)
            ? error.error.msg
            : error.message;
          console.log(msg);
          this.commonService.regularToaster(
            'error',
            'Bilan non mise à jour. Une erreur est survenue sur le serveur.'
          );
        }
      );
  }

  private getAssessmentData() {
    const assessmentData = Object.assign({}, this.form.value);

    if (this.updateMode.getValue()) {
      assessmentData['assessment']['id'] = this.assessment.id;
    }
    assessmentData["assessment"]["idPriorityTaxon"] = this.priorityTaxonId;

    return assessmentData;
  }

}

