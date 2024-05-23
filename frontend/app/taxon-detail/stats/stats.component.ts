import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FormBuilder } from '@angular/forms';

import { Observable } from '@librairies/rxjs';

import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';
import { IStats } from '../../shared/models/stats.model';

@Component({
    selector: 'cs-stats',
    templateUrl: './stats.component.html',
    styleUrls: ['./stats.component.scss']
})
export class StatsComponent implements OnInit {

    stats: Observable<IStats>;
    statsForm = this.formBuilder.group({
        dateStart: [new Date()],
        nbYear: [5]
    })
    taxonCode: number;
    territoryCode: string;
    territoryType: string;

    constructor(
        private dataService: DataService,
        private storeService: StoreService,
        private formBuilder: FormBuilder,
        public route: ActivatedRoute,
    ) { }

    ngOnInit(): void {
        this.storeService.$selectedPriorityTaxonData.subscribe(data => {
            this.taxonCode = data.taxonCode;
            let territoryId = data.territoryId;
            if (territoryId != null) {
                this.dataService.getTerritory(territoryId).subscribe(territory => {
                    this.territoryCode = territory.areaCode;
                    this.territoryType = territory.areaType;
                    this.loadStats();
                });
            }
        })
    }

    loadStats() {
        this.stats = this.dataService.getStatsPriorityFlora({
            'area-code': this.territoryCode,
            'area-type': this.territoryType,
            'taxon-code': this.taxonCode,
            'date-start': this.statsForm.value.dateStart.toISOString().split('T')[0],
            'years-nbr': this.statsForm.value.nbYear
        })
    }
}
