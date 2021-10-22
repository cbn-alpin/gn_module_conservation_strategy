import { Component, OnInit } from '@angular/core';

import { ConfigService } from "./services/config.service";
import { DataService } from "./services/data.service";


@Component({
  selector: 'gn-cs-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class CsRootComponent implements OnInit {
  title: String;
  $territories;

  constructor(
    private cfg: ConfigService,
    private data: DataService,
  ) {
    this.title = this.cfg.getModuleTitle();
    this.$territories = this.data.getTerritories();
    console.log(this.$territories)
  }

  ngOnInit() {

  }
}
