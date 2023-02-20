import { Injectable } from "@angular/core";
import { HttpClient, HttpParams } from "@angular/common/http";

import { Observable } from "@librairies/rxjs";
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

import { ConfigService } from "./config.service";
import { IOrganism } from "../models/assessment.model";
import { ITasks } from "../../strategy/planning/planning.datasource";
import { IStats, IStatParams } from "../models/stats.model";

// TODO: use StoreService to get territory code and taxon name code.
@Injectable()
export class DataService {

  constructor(
    private cfg: ConfigService,
    private http: HttpClient,
  ) { }

  getTerritories() {
    const url = `${this.cfg.getModuleBackendUrl()}/territories`;
    return this.http.get<any>(url);
  }

  getTerritory(territoryId: number) {
    const url = `${this.cfg.getModuleBackendUrl()}/territories/${territoryId}`;
    return this.http.get<any>(url);
  }

  getHomePage(): Observable<string> {
    const path = 'external_assets/conservation_strategy/templates/home.tpl.html';
    return this.http.get(path, { responseType: 'text' });
  }

  getPriorityTaxa(params: HttpParams) {
    const url = `${this.cfg.getModuleBackendUrl()}/taxons`;
    return this.http.get<any>(url, { params });
  }

  getPriorityTaxon(priorityTaxonId: number) {
    const url = `${this.cfg.getModuleBackendUrl()}/taxons/${priorityTaxonId}`;
    return this.http.get<any>(url);
  }

  getTaxonInfos(priorityTaxonId: BehaviorSubject<number>, params = {}) {
    const url = `${this.cfg.getModuleBackendUrl()}/taxons/${priorityTaxonId}`;
    return this.http.get<any>(url, { params });
  }

  addAssessment(assessmentData: any): Observable<any> {
    const url = `${this.cfg.getModuleBackendUrl()}/assessments`;
    return this.http.post<any>(url, assessmentData);
  }

  updateAssessment(data: any): Observable<any> {
    const url = `${this.cfg.getModuleBackendUrl()}/assessments/${data.assessment.id}`;
    return this.http.put<any>(url, data);
  }

  getAssessments(params: {} = {}) {
    const url = `${this.cfg.getModuleBackendUrl()}/assessments`;
    return this.http.get<any>(url, { params });
  }

  getAssessment(assessmentId: number, params: {} = {}) {
    const url = `${this.cfg.getModuleBackendUrl()}/assessments/${assessmentId}`;
    return this.http.get<any>(url, { params });
  }

  getOrganisms(): Observable<IOrganism[]> {
    const url = `${this.cfg.getModuleBackendUrl()}/organisms`;
    return this.http.get<any>(url);
  }

  getTasks(params: HttpParams): Observable<ITasks> {
    const url = `${this.cfg.getModuleBackendUrl()}/tasks`;
    return this.http.get<any>(url, { params });
  }

  getNomenclatures(type): Observable<any> {
    const url = `${this.cfg.getBackendUrl()}/nomenclatures/nomenclature/${type}`;
    return this.http.get<any>(url);
  }

  getStatsPriorityFlora(params: IStatParams): Observable<IStats> {
    let statParams = new HttpParams();
    for (let key in params) {
      statParams = statParams.set(key, params[key]);
    }
    const url = `${this.cfg.getPriorityFloraBackendUrl()}/stats`;
    return this.http.get<any>(url, { params: statParams });
  } 
}
