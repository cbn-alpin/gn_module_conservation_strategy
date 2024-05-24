import { CommonModule, registerLocaleData } from '@angular/common';
import localeFr from '@angular/common/locales/fr';
import { HttpClient } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { ExtraOptions, RouterModule } from '@angular/router';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialogModule, MAT_DIALOG_DEFAULT_OPTIONS } from '@angular/material/dialog';
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatPaginatorModule, MatPaginatorIntl } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSliderModule } from '@angular/material/slider';
import { MatSortModule } from '@angular/material/sort';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTooltipModule } from '@angular/material/tooltip';
import { NgxMatMomentModule } from '@angular-material-components/moment-adapter';

import { CarouselModule } from 'ngx-bootstrap/carousel';

import { GN2CommonModule } from '@geonature_common/GN2Common.module';

import { ActionForm } from './taxon-detail/assessments-list/assessment-form/action-form/action-form.component';
import { AssessmentForm } from './taxon-detail/assessments-list/assessment-form/assessment-form.component';
import { AssessmentDetailComponent } from './taxon-detail/assessments-list/assessment-detail/assessment-detail.component';
import { CustomPaginator } from './shared/services/custom-paginator.intl';
import { BreadcrumbsComponent } from './shared/components/breadcrumbs/breadcrumbs.component';
import { ConfirmDialogComponent } from './shared/components/confirm-dialog/confirm-dialog.component';
import { ConfigService } from './shared/services/config.service';
import { AssessmentsListComponent } from './taxon-detail/assessments-list/assessments-list.component';
import { HomeComponent } from './strategy/home/home.component';
import { PlanningComponent } from './strategy/planning/planning.component';
import { StatsComponent } from './taxon-detail/stats/stats.component';
import { RootComponent } from './root/root.component';
import { StrategyComponent } from './strategy/strategy.component';
import { TaxaListComponent } from './strategy/taxa-list/taxa-list.component'
import { TaxonDetailComponent } from './taxon-detail/taxon-detail.component'
import { DataService } from './shared/services/data.service';
import { DialogService } from './shared/components/confirm-dialog/confirm-dialog.service';
import { ReplaceTagsPipe } from './shared/pipes/replace-tags.pipe';
import { routes } from './gnModule.routes';
import { SimpleNomenclatureComponent } from './shared/components/form/simple-nomenclature/simple-nomenclature.component';
import { SortByPipe } from './shared/pipes/sort-by.pipe';
import { StoreService } from './shared/services/store.service';
import { TaxaFilterComponent } from './shared/components/taxa-filter/taxa-filter.component';
import { TaxonInfosComponent } from './taxon-detail/taxon-infos/taxon-infos.component';


export const routingConfiguration: ExtraOptions = {
  paramsInheritanceStrategy: 'always'
};

@NgModule({
  declarations: [
    ActionForm,
    AssessmentDetailComponent,
    AssessmentForm,
    BreadcrumbsComponent,
    ConfirmDialogComponent,
    AssessmentsListComponent,
    HomeComponent,
    PlanningComponent,
    RootComponent,
    StrategyComponent,
    TaxaListComponent,
    TaxonDetailComponent,
    ReplaceTagsPipe,
    SimpleNomenclatureComponent,
    SortByPipe,
    TaxaFilterComponent,
    TaxonInfosComponent,
    StatsComponent,
  ],
  imports: [
    CarouselModule.forRoot(),
    CommonModule,
    GN2CommonModule,
    MatCheckboxModule,
    MatDatepickerModule,
    MatDialogModule,
    MatInputModule,
    NgxMatMomentModule,
    MatPaginatorModule,
    MatProgressBarModule,
    MatProgressSpinnerModule,
    MatSelectModule,
    MatSidenavModule,
    MatSliderModule,
    MatSortModule,
    MatTableModule,
    MatTabsModule,
    MatTooltipModule,
    RouterModule.forChild(routes),
  ],
  providers: [
    ConfigService,
    DataService,
    DialogService,
    HttpClient,
    StoreService,
    {
      provide: MatPaginatorIntl,
      useValue: CustomPaginator(),
    },
    {
      provide: MAT_DATE_LOCALE,
      useValue: 'fr',
    },
    {
      provide: MAT_DIALOG_DEFAULT_OPTIONS,
      useValue: {
        hasBackdrop: true,
      }
    },
    {
      provide: MAT_FORM_FIELD_DEFAULT_OPTIONS,
      useValue: {
        floatLabel: 'never',// always, never, or auto.
        appearance: 'outline',// standard, fill and outline
      }
    },
  ],
  entryComponents: [
    ActionForm,
    AssessmentForm,
    ConfirmDialogComponent,
  ],
  bootstrap: []
})
export class GeonatureModule {
  constructor() {
    // TODO: remove line below with GN 2.8.0+
    registerLocaleData(localeFr, 'fr');
  }
}
