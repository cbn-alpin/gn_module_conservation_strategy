import { filter, distinctUntilChanged } from 'rxjs/operators';

import { Observable } from 'rxjs';
import { Component, OnInit, } from "@angular/core";
import { ActivatedRoute, ActivatedRouteSnapshot, Event, ParamMap, NavigationEnd, Router } from "@angular/router";

import { IBreadCrumb } from './breadcrumb.interface';

/**
 * Classe building breadcrumbs with routes configurations (see gnModule.module.ts file).
 *
 * Source: https://medium.com/@bo.vandersteene/angular-5-breadcrumb-c225fd9df5cf
 * See also: https://vsavkin.tumblr.com/post/146722301646/angular-router-empty-paths-componentless-routes
 */
@Component({
  selector: "cs-breadcrumbs",
  templateUrl: "./breadcrumbs.component.html",
})
export class BreadcrumbsComponent implements OnInit {
  public newBreadcrumbs: IBreadCrumb[] = [];
  public breadcrumbs: IBreadCrumb[] = [];

  constructor(
    private router: Router,
    private activatedRoute: ActivatedRoute
  ) {
    this.buildBreadCrumbObservable(this.activatedRoute.root);
  }

  ngOnInit() {
    // On page load...
    this.breadcrumbs = [];
    this.buildBreadCrumbObservable(this.activatedRoute.root);

    // On Router navigation event...
    this.router.events.pipe(
        filter((event: Event) => event instanceof NavigationEnd),
        distinctUntilChanged(),
    ).subscribe(() => {
      this.breadcrumbs = [];
      this.buildBreadCrumbObservable(this.activatedRoute.root);
    });
  }

  /**
   * Recursively build breadcrumb according to activated route.
   * @param route
   * @param url
   * @param breadcrumbs
   */
  buildBreadCrumbObservable(route: ActivatedRoute, url: string = ''): void {
    let breadcrumb: IBreadCrumb = route.routeConfig && route.routeConfig.data && route.routeConfig.data.breadcrumb
      ? route.routeConfig.data.breadcrumb
      : {label: '', iconClass: '', title: '', url: '', disable: false,};

    let path = route.routeConfig && route.routeConfig.path
      ? route.routeConfig.path
      : '';
    breadcrumb.url = path ? `${url}/${path}` : url;

    if (breadcrumb.labelTpl == undefined) {
      breadcrumb.labelTpl = `${breadcrumb.label}`;
    }

    // Only adding route with non-empty label
    if (breadcrumb.label) {
      this.breadcrumbs.push(breadcrumb);
    }

    if (path != '') {
      const routeParts = path.split('/');
      for (const routePart of routeParts) {
        const isDynamicRoutePart = routePart.startsWith(':');
        if (isDynamicRoutePart) {
          route.paramMap.subscribe((params : ParamMap) => {
            for (const key of params.keys) {
              const value = params.get(key);
              for (let entry of this.breadcrumbs) {
                if (entry.url.includes(`:${key}`)) {
                  entry.url = entry.url.replace(`:${key}`, value);
                }
                if (entry.labelTpl.includes(`:${key}`)) {
                  entry.label = entry.labelTpl.replace(`:${key}`, value);
                }
              }
            }
          });
        }
      }
    }

    if (route.firstChild) {
        // If we are not on our current path yet,
        // there will be more children to look after, to build our breadcumb
        this.buildBreadCrumbObservable(route.firstChild, breadcrumb.url);
    }
  }
}
