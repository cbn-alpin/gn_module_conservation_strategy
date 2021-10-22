import { Routes } from '@angular/router';

import { CsRootComponent } from './app.component';


export const routes: Routes = [
  {
    path: '',
    redirectTo: 'home',
    pathMatch: 'full',
  },
  {
    path: 'home',
    data: {
      breadcrumb: {
        label: 'Accueil CS',
        title: "Page d'accueil du module Stratégie Conservation.",
        iconClass: 'fa fa-home',
      }
    },
    children: [
      {
        path: '',
        component: CsRootComponent,
      },
    ]
  }
] ;
