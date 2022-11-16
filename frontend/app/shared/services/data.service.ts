import { Injectable } from "@angular/core";
import { HttpClient, HttpParams } from "@angular/common/http";

import { Observable } from "@librairies/rxjs";

import { ConfigService } from "./config.service";
import { StoreService } from "./store.service";
import { IOrganism } from "../models/assessment.model";


// TODO: use StoreService to get territory code and taxon name code.
@Injectable()
export class DataService {

  constructor(
    private cfg: ConfigService,
    private http: HttpClient,
    private store: StoreService,
  ) {}

  getTerritories() {
    const url = `${this.cfg.getModuleBackendUrl()}/territories`;
    return this.http.get<any>(url);
  }

  getTerritory(territoryCode: string) {
    const url = `${this.cfg.getModuleBackendUrl()}/territories/${territoryCode}`;
    return this.http.get<any>(url);
  }

  getHomePage(): Observable<string> {
    const path = 'external_assets/conservation_strategy/templates/home.tpl.html';
    return this.http.get(path, {responseType: 'text'});
  }

  getPriorityTaxa(params: HttpParams) {
    params = params.set('territory-code', this.store.selectedTerritory.code.toLowerCase());
    const url = `${this.cfg.getModuleBackendUrl()}/taxons`;
    return this.http.get<any>(url, {params});
  }

  getPriorityTaxon(priorityTaxonId: number) {
    const url = `${this.cfg.getModuleBackendUrl()}/taxons/${priorityTaxonId}`;
    return this.http.get<any>(url);
  }

  getTaxonInfos(priorityTaxonId: number, params = {}) {
    const url = `${this.cfg.getModuleBackendUrl()}/taxons/${priorityTaxonId}`;
    return this.http.get<any>(url, {params});
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
    return this.http.get<any>(url, {params});
  }

  getAssessment(assessmentId: number, params: {} = {}) {
    const url = `${this.cfg.getModuleBackendUrl()}/assessments/${assessmentId}`;
    return this.http.get<any>(url, {params});
  }

  getOrganisms(): Observable<IOrganism[]> {
    const url = `${this.cfg.getModuleBackendUrl()}/organisms`;
    return this.http.get<any>(url);
  }
}
