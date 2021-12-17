import { Component, OnInit, Input, Output, EventEmitter, ViewEncapsulation } from '@angular/core';
import { FormControl } from '@angular/forms';
import { HttpClient } from "@angular/common/http";

import { Observable, of } from 'rxjs';

import { CommonService } from '@geonature_common/service/common.service';

export interface TaxonName {
  cdNom: Number;
  cdRef: Number;
  searchName: string;
  nomValide: string;
  idxTrgm: Number;
}

/**
 * Ce composant permet de créer un "input" de type "typeahead" pour
 * rechercher des taxons à partir d'une liste définit dans schéma
 * taxonomie. Table ``taxonomie.bib_listes`` et ``taxonomie.cor_nom_listes``.
 *
 *  @example
 * <cs-taxa-filter
 *    #taxon
 *    label="{{ 'Taxon.Taxon' | translate }}
 *    [parentFormControl]="occurrenceForm.controls.cd_nom"
 *    [apiEndPoint]="http://127.0.0.1:8000/names"
 *    [charNumber]="3"
 *    [listLength]="config.taxon_result_number"
 *    (onChange)="fs.onTaxonChanged($event);"
 * >
 * </cs-taxa-filter>
 *
 */
@Component({
  selector: 'cs-taxa-filter',
  templateUrl: './taxa-filter.component.html',
  styleUrls: ['./taxa-filter.component.scss'],
  encapsulation: ViewEncapsulation.None
})
export class TaxaFilterComponent implements OnInit {
  /** Nom du champ. */
  @Input() label: string;
  /** Reactive form associé. */
  @Input() parentFormControl: FormControl;
  /** URL à utiliser pour l'auto-complétion. */
  @Input() apiEndPoint: string;
  /** Objet contenant des paramètres à ajouter à l'URL utiliser pour l'auto-complétion. */
  @Input() apiParams: Record<string, string>;
  /** Nombre de charactere avant que la recherche AJAX soit lançée (obligatoire). */
  @Input() charNumber: number = 3;
  /** Nombre de lignes de résultat à afficher. */
  @Input() listLength = 20;
  public filteredTaxons: any;
  public noResult: boolean;
  public isLoading = false;
  private selectedName: TaxonName
  /** Envoie le TaxonName selectionné. */
  @Output() onChange = new EventEmitter<TaxonName>();
  /** Envoie le TaxonName supprimé. */
  @Output() onDelete = new EventEmitter<TaxonName>();

  constructor(
    private http: HttpClient,
    private commonService: CommonService,
  ) {}

  ngOnInit() {
    this.parentFormControl.valueChanges
      .filter(value => value !== null && value.length === 0)
      .subscribe(value => {
        this.onDelete.emit(this.selectedName);
      });
  }

  onTaxonSelected(event: NgbTypeaheadSelectItemEvent) {
    this.selectedName = event.item;
    this.onChange.emit(event.item);
  }

  onClearField() {
    this.onDelete.emit(this.selectedName);
    this.parentFormControl.reset();
    this.selectedName = null;
  }

  formatter(taxon) {
    return taxon.nomValide;
  }

  searchTaxon = (text$: Observable<string>) =>
    text$
      .do(() => (this.isLoading = true))
      .debounceTime(400)
      .distinctUntilChanged()
      .switchMap(search => {
        if (search.length >= this.charNumber) {
          return this.autocomplete({
              q: search,
              limit: this.listLength.toString()
            })
            .catch(err => {
              if (err.status_code === 500) {
                this.commonService.translateToaster('error', 'ErrorMessage');
              }
              return of([]);
            });
        } else {
          this.isLoading = false;
          return [[]];
        }
      })
      .map(response => {
        this.noResult = response.length === 0;
        this.isLoading = false;
        return response;
      });

  autocomplete(params) {
    let urlParams = {...this.apiParams, ...params};
    return this.http.get<any>(this.apiEndPoint, {'params': urlParams});
  }

  refreshAllInput() {
    this.parentFormControl.reset();
  }
}
