import { Routes } from '@angular/router';

import { CsRootComponent } from './root/root.component';
import { CsAssessmentsListComponent } from './taxon-detail/assessments-list/assessments-list.component';
import { CsHomeComponent } from './strategy/home/home.component';
import { CsStrategyComponent } from './strategy/strategy.component';
import { CsTaxonDetailComponent } from './taxon-detail/taxon-detail.component';
import { CsTaxaListComponent } from './strategy/taxa-list/taxa-list.component';
import { TaxonInfosComponent } from './taxon-detail/taxon-infos/taxon-infos.component';
import { CsPlanningComponent } from './strategy/planning/planning.component';

export const routes: Routes = [
  {
    path: '',
    component: CsRootComponent,
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
        component: CsStrategyComponent,
        children: [
          {
            path: '',
            component: CsHomeComponent,
          },
          {
            path: '',
            redirectTo: 'planning',
            pathMatch: 'full',
          },
          {
            path: 'planning',
            data: {
              breadcrumb: {
                label: 'Planning des actions à mener',
                title: 'Planning des actions à mener pour chaque organisme selon les bilans stationnels effectués',
                iconClass: 'fa fa-calendar',
              }
            },
            children: [
              {
                path: '',
                component: CsPlanningComponent,
              },
            ]
          },
          {
            path: 'territories',
            redirectTo: '/conservation_strategy',
            pathMatch: 'full',
          },
          {
            path: 'territories/:territoryCode',
            data: {
              breadcrumb: {
                label: 'Territoire : :territoryCode',
                title: "Liste des taxons prioritaires du module Stratégie Conservation.",
                iconClass: 'fa fa-globe',
                disable: true,
              }
            },
            children: [
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
                    component: CsTaxaListComponent,
                  },
                ]
              }
            ]
          }
        ],
      },
      {
        path: 'territories/:territoryCode',
        data: {
          breadcrumb: {
            label: 'Territoire : :territoryCode',
            title: "Liste des taxons prioritaires du module Stratégie Conservation.",
            iconClass: 'fa fa-globe',
            disable: true,
          }
        },
        children: [
          {
            path: 'priority-taxa',
            data: {
              breadcrumb: {
                label: 'Taxons prioritaires ',
                title: "Liste des taxons prioritaires du module Stratégie Conservation.",
                iconClass: 'fa fa-list',
              }
            },
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
                    component: CsTaxonDetailComponent,
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
                        component: CsAssessmentsListComponent,
                        data: {
                          breadcrumb: {
                            label: 'Bilans stationnels',
                            title: 'Liste des bilans stationnels d\'un taxon prioritaire du module Stratégie Conservation.',
                            iconClass: 'fa fa-heartbeat',
                          }
                        },
                      },
                    ]
                  },
                ]
              }
            ]
          },
        ]
      },
    ],
  },
];
