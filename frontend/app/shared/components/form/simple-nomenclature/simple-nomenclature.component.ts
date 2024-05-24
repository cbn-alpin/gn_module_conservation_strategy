import { Component, EventEmitter, Input, OnDestroy, OnInit, Output, ViewChild, ViewEncapsulation } from "@angular/core";

import { Subscription } from "rxjs";
import { TranslateService, LangChangeEvent } from '@ngx-translate/core';

import { DataFormService } from "@geonature_common/form/data-form.service";
import { GenericFormComponent } from "@geonature_common/form/genericForm.component";
import { MatOption, MatSelect, MatSelectChange } from "@angular/material";

/**
 * Ce composant permet de créer un "input" de type "mat-select" à partir
 * d'une liste d'items définie dans le référentiel de nomenclatures
 * (thésaurus) de GeoNature (table ``ref_nomenclature.t_nomenclature``).
 *
 * En mode "multiple" (Input ``multiple=true``), des cases à cocher préfixe
 * chaque option et permettent de sélectionner plusieurs entrées.
 *
 * @example
 * <cs-simple-nomenclature
 *    label="Mon intitulé de champ"
 *    [parentFormControl]="myForm.controls.id_nomenclature_etat_bio"
 *    codeNomenclatureType="ETA_BIO"
 *    keyValue="cd_nomenclature"
  *   [multiSelect]="true"
 * >
 * </cs-simple-nomenclature>
 */
 @Component({
  selector: 'cs-simple-nomenclature',
  templateUrl: './simple-nomenclature.component.html',
  //styleUrls: ['./nomenclature.component.scss'],
  encapsulation: ViewEncapsulation.None
})
export class SimpleNomenclatureComponent extends GenericFormComponent implements OnInit, OnDestroy {
  public labels: Array<any>;
  public labelLang: string;
  public definitionLang: string;
  public langChangesubscription: Subscription;
  public valueChangeSubscription: Subscription;
  public currentCdNomenclature = 'null';
  public currentIdNomenclature: number;
  public savedLabels;
  @ViewChild('matSelect') selectInput: MatSelect;
  /**
   * Mnémonique du type de nomenclature qui doit être affiché dans la liste déroulante.
   *  Table``ref_nomenclatures.bib_nomenclatures_types`` (obligatoire)
   */
  @Input() codeNomenclatureType: string;
  /**
   * Attribut de l'objet nomenclature renvoyé au formControl (facultatif, par défaut ``id_nomenclature``).
   * Valeur possible: n'importequel attribut de l'objet ``nomenclature`` renvoyé par l'API
   */
  @Input() keyValue;
  @Output() labelsLoaded = new EventEmitter<Array<any>>();
  @Output() change = new EventEmitter<{text: string, value: any}>();

  constructor(
    private dataFormService: DataFormService,
    private translateService: TranslateService,
  ) {
    super();
  }

  ngOnInit() {
    this.keyValue = this.keyValue || 'id_nomenclature';
    this.labelLang = 'label_' + this.translateService.currentLang;
    this.definitionLang = 'definition_' + this.translateService.currentLang;

    // Load the data
    this.initLabels();

    // Subscribe to the language change
    this.langChangesubscription = this.translateService.onLangChange.subscribe((event: LangChangeEvent) => {
      this.labelLang = 'label_' + this.translateService.currentLang;
      this.definitionLang = 'definition_' + this.translateService.currentLang;
    });

    // Set cdNomenclature
    this.valueChangeSubscription = this.parentFormControl.valueChanges.subscribe(id => {
      this.currentIdNomenclature = id;
      const self = this;
      if (this.labels) {
        this.labels.forEach(label => {
          if (this.currentIdNomenclature === label.id_nomenclature) {
            self.currentCdNomenclature = label.cd_nomenclature;
          }
        });
      }
    });

    // Disable form control if necessary
    if (this.disabled) {
      this.parentFormControl.disable();
    }
  }

  getCdNomenclature() {
    let cdNomenclature;
    if (this.labels) {
      this.labels.forEach(label => {
        if (this.currentIdNomenclature === label.id_nomenclature) {
          cdNomenclature = label.cd_nomenclature;
        }
      });
      return cdNomenclature;
    }
  }

  initLabels() {
    const filters = { orderby: 'label_default' };
    this.dataFormService
      .getNomenclature(this.codeNomenclatureType, undefined, undefined, undefined, filters)
      .subscribe(data => {
        this.labels = data.values;
        this.savedLabels = data.values;
        this.labelsLoaded.emit(this.labels);
      });
  }

  onNomenclatureSelected(event: MatSelectChange) {
    let text;
    if (event.source.multiple) {
      text = [];
      (event.source.selected as Array<MatOption>).forEach((option) => {
        text.push(option.viewValue);
      });
    } else {
      text = (event.source.selected as MatOption).viewValue;
    }
    const selectedData = {
      text: text,
      value: event.source.value
    };
    this.change.emit(selectedData);
  }

  onNomenclatureReset(event) {
    event.stopPropagation();
    this.parentFormControl.reset()
  }

  ngOnDestroy() {
    this.langChangesubscription.unsubscribe();
    this.valueChangeSubscription.unsubscribe();
  }

}
