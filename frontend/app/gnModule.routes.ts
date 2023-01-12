import { Routes } from '@angular/router';

import { RootComponent } from './root/root.component';
import { AssessmentsListComponent } from './taxon-detail/assessments-list/assessments-list.component';
import { HomeComponent } from './strategy/home/home.component';
import { StrategyComponent } from './strategy/strategy.component';
import { TaxonDetailComponent } from './taxon-detail/taxon-detail.component';
import { TaxaListComponent } from './strategy/taxa-list/taxa-list.component';
import { TaxonInfosComponent } from './taxon-detail/taxon-infos/taxon-infos.component';
import { PlanningComponent } from './strategy/planning/planning.component';

export const routes: Routes = [
  {
    path: '',
    component: RootComponent,
    data: {
      breadcrumb: {
        label: 'Accueil Stratégie Conservation',
        title: "Page d'accueil du module Stratégie Conservation.",
        iconClass: 'fa fa-home',
      }
    },
    children: [
      {
        path: '',
        component: StrategyComponent,
        children: [
          {
            path: '',
            component: HomeComponent,
          },
          {
            path: 'planning',
            component: PlanningComponent,
            data: {
              breadcrumb: {
                label: 'Planning des actions à mener',
                title: 'Planning des actions à mener pour chaque organisme selon les bilans stationnels effectués',
                iconClass: 'fa fa-calendar',
              }
            }
          },
          {
            path: '',
            redirectTo: 'priority-taxa',
            pathMatch: 'full',
          },
          {
            path: 'priority-taxa',
            data: {
              breadcrumb: {
                label: 'Taxons prioritaires',
                title: "Liste des taxons prioritaires du module Stratégie Conservation.",
                iconClass: 'fa fa-list',
              }
            },
            children: [
              {
                path: '',
                component: TaxaListComponent,
                children: [
                  {
                    path: ':priorityTaxonId',
                    data: {
                      breadcrumb: {
                        label: 'Taxon : :shortName',
                        title: 'Détail d\'un taxon prioritaire du module Stratégie Conservation.',
                        iconClass: 'fa fa-leaf',
                        disable: true,
                      }
                    },
                    children: [
                      {
                        path: '',
                        component: TaxonDetailComponent,
                        children: [
                          {
                            path: '',
                            redirectTo: 'infos',
                            pathMatch: 'full',
                          },
                          {
                            path: 'infos',
                            component: TaxonInfosComponent,
                            data: {
                              breadcrumb: {
                                label: 'Infos générales',
                                title: 'Informations générales sur le taxon prioritaire.',
                                iconClass: 'fa fa-info-circle',
                              }
                            },
                          },
                          {
                            path: 'assessments',
                            data: {
                              breadcrumb: {
                                label: 'Bilans stationnels',
                                title: 'Liste des bilans stationnels d\'un taxon prioritaire du module Stratégie Conservation.',
                                iconClass: 'fa fa-heartbeat',
                              }
                            },
                            children: [
                              {
                                path: '',
                                component: AssessmentsListComponent,
                              },
                              {
                                path: ':assessmentId',
                                data: {
                                  breadcrumb: {
                                    label: 'Bilan Stationnel : :assessmentId',
                                    title: "Fiche Bilan Stationnel.",
                                    iconClass: 'fa fa-heartbeat',
                                  }
                                },
                                children: [
                                  {
                                    path: '',
                                    component: AssessmentsListComponent,
                                  },
                                  {
                                    path: 'actions/:actionId',
                                    component: AssessmentsListComponent,
                                    data: {
                                      breadcrumb: {
                                        label: 'Action : :actionId',
                                        title: "Action à mener",
                                        iconClass: 'fa fa-bolt',
                                      }
                                    },
                                  },
                                ],
                              },
                            ]
                          },
                        ]
                      },
                    ]
                  },
                ]
              },
            ]
          },
        ],
      },
    ]
  },
];
