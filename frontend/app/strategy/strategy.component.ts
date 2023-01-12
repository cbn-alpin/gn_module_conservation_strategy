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
export class StrategyComponent implements OnInit {
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
  }
}
