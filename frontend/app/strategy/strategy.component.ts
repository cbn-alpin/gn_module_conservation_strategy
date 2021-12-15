import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRouteSnapshot, NavigationEnd, Router } from '@angular/router';

import { Subscription } from 'rxjs';
import { filter, map } from 'rxjs/operators'

import { ConfigService } from "../shared/services/config.service";
import { DataService } from "../shared/services/data.service";
import { StoreService } from '../shared/services/store.service';

@Component({
  selector: 'cs-strategy',
  templateUrl: './strategy.component.html',
  styleUrls: ['./strategy.component.scss']
})
export class CsStrategyComponent implements OnInit, OnDestroy {
  title: String;
  currentTerritory;
  $territories;
  territoryAlreadySelected: Boolean = false;
  subscription: Subscription;

  constructor(
    private router: Router,
    private cfg: ConfigService,
    private data: DataService,
    private store: StoreService,
  ) {}

  ngOnInit() {
    this.title = this.cfg.getModuleTitle();

    this.onRouterNavigationEnd();

    const urlParams = this.collectRouteParams();
    this.initializeWithUrlParams(urlParams);
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

  private onRouterNavigationEnd() {
    this.subscription = this.router.events.pipe(
      filter(e => e instanceof NavigationEnd)
    ).subscribe((e) => {
      const urlParams = this.collectRouteParams();
      if (this.currentTerritory && this.currentTerritory.code != urlParams.get('territoryCode')) {
        this.initializeWithUrlParams(urlParams);
      }
    });
  }

  private collectRouteParams(): Map<string, string> {
    let params = new Map();
    let stack: ActivatedRouteSnapshot[] = [this.router.routerState.snapshot.root];
    while (stack.length > 0) {
      const route = stack.pop()!;
      for (let paramKey in route.params) {
        params.set(paramKey, route.params[paramKey]);
      }
      stack.push(...route.children);
    }
    return params;
  }

  private initializeWithUrlParams(urlParams) {
    if (urlParams.has('territoryCode')) {
      let territoryCode = urlParams.get('territoryCode');
      this.data.getTerritory(territoryCode).subscribe(data => {
        this.store.selectedTerritory = data;
        this.currentTerritory = this.store.selectedTerritory;
        this.territoryAlreadySelected = true;
        this.loadTerritories();
      });
    } else {
      if (this.store.selectedTerritory == undefined) {
        this.territoryAlreadySelected = false;
      } else {
        this.currentTerritory = this.store.selectedTerritory;
        this.territoryAlreadySelected = true;
      }
      this.loadTerritories();
    }
  }

  private loadTerritories() {
    this.$territories = this.data.getTerritories().pipe(
      map(territories => {
        let territoriesWithParent = [];
        let biggerTerritory;
        territories.forEach((item) => {
          if (item.idParent) {
            territoriesWithParent.push(item);
            if (
              !this.territoryAlreadySelected
              && (!biggerTerritory || biggerTerritory.meshesTotal < item.meshesTotal)
            ) {
              biggerTerritory = item;
              this.currentTerritory = item;
            } else if (
              this.territoryAlreadySelected
              && this.currentTerritory.code == item.code
            ) {
              this.currentTerritory = item;
            }
          }
        });
        if (!this.territoryAlreadySelected && this.currentTerritory != undefined) {
          this.store.selectedTerritory = Object.assign(this.currentTerritory);
        }
        return territoriesWithParent
      })
    );
  }

  onTerritoryChanged(event) {
    console.log('Territory changed:', event.value)
    this.store.selectedTerritory = Object.assign(this.currentTerritory);
    this.router.navigate(['cs', 'territories', this.currentTerritory.code, 'priority-taxa']);
  }
}
