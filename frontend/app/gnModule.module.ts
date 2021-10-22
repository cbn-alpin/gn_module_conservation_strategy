import { CommonModule } from '@angular/common';
import { HttpClientModule, HttpClient} from '@angular/common/http';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { ToastrService, ToastrModule } from 'ngx-toastr';

import { GN2CommonModule } from '@geonature_common/GN2Common.module';

import { CsRootComponent } from './app.component';
import { BreadcrumbsComponent } from './components/breadcrumbs/breadcrumbs.component';
import { ConfigService } from './services/config.service';
import { DataService } from './services/data.service';
import { routes } from './app-routing.module';


@NgModule({
  declarations: [
    CsRootComponent,
    BreadcrumbsComponent,
  ],
  imports: [
    CommonModule,
    GN2CommonModule,
    HttpClientModule,
    RouterModule.forChild(routes),
    ToastrModule.forRoot(),
  ],
  providers: [
    ConfigService,
    DataService,
    HttpClient, 
    ToastrService,
  ],
  bootstrap: []
})
export class GeonatureModule {}
