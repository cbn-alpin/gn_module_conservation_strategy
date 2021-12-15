import { Component, OnInit } from '@angular/core';

import { Observable } from 'rxjs/internal/Observable';

import { ConfigService } from '../../shared/services/config.service';
import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';

@Component({
  selector: 'cs-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class CsHomeComponent implements OnInit {

  homeContent: Observable<string>;

  constructor(
    private dataService: DataService,
    public store: StoreService,
  ) {}

  ngOnInit() {
    this.homeContent = this.dataService.getHomePage();
  }
}
