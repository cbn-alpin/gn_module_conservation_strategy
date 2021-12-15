import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { AbstractControl, FormGroup } from "@angular/forms";
import { Observable } from "@librairies/rxjs";
import { DialogService } from "../../../../shared/components/confirm-dialog/confirm-dialog.service";
import { IAction, IOrganism } from "../../../../shared/models/assessment.model";
import { DataService } from "../../../../shared/services/data.service";

@Component({
  selector: 'cs-action-form',
  templateUrl: './action-form.component.html',
  styleUrls: ['./action-form.component.scss'],
})
export class ActionForm implements OnInit {

  currentYear: number;
  level: string;
  type: string;
  partners: Observable<IOrganism[]>;
  progress: string;
  progressValue: string;
  @Input() action: Partial<IAction>;
  @Input() actionNumber;
  @Input() parentFormGroup: AbstractControl;
  @Input() uuid: string;
  @Output() deleted = new EventEmitter<string>();

  constructor(
    private dataService: DataService,
    private dialogService: DialogService,
  ) {
    this.currentYear = (new Date()).getFullYear();
    this.partners = this.dataService.getOrganisms();
  }

  ngOnInit(): void {
    this.initializeActionInfos();
  }

  private initializeActionInfos() {
    this.level = this.action.level;
    this.type = this.action.type;
    this.progress = this.action.progress;
    this.progressValue = this.action.progressCode;
  }

  onLevelNomenclatureChange(event: {text: string, value: string}) {
    this.level = event ? event.text as string : '';
  }

  onTypeChange(event: {text: string, value: string}) {
    this.type = event ? event.text as string : '';
  }

  onProgressChange(event: {text: string, value: string}) {
    const formCtrls = (this.parentFormGroup as FormGroup).controls;
    formCtrls.planFor.reset();
    formCtrls.startingDate.reset();
    formCtrls.implementationDate.reset();
    this.progress = event ? event.text as string : '';
    this.progressValue = event ? event.value as string : '';
  }

  onPlanForSliderChange(event, planForCtrl: AbstractControl) {
    planForCtrl.setValue(event.value);
  }

  onDeleteAction() {
    this.dialogService
      .confirmDialog({message: 'Étes vous certain de vouloir supprimer cet action ?'})
      .subscribe((yes) => {
        if (yes) {
          this.deleted.emit(this.uuid);
        }
      });
  }
}
