import { Component, OnInit } from '@angular/core';

import { ConfigService } from "../shared/services/config.service";

@Component({
  selector: 'cs-strategy',
  templateUrl: './strategy.component.html',
  styleUrls: ['./strategy.component.scss']
})
export class StrategyComponent implements OnInit {
  title: String;

  constructor(
    private cfg: ConfigService,
  ) {}

  ngOnInit() {
    this.title = this.cfg.getModuleTitle();
  }
}
