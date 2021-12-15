import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";

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
    const path = 'assets/cs/templates/home.tpl.html';
    return this.http.get(path, {responseType: 'text'});
  }

  getPriorityTaxa(params) {
    const urlPath = `territories/${this.store.selectedTerritory.code.toLowerCase()}/taxons`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.get<any>(url, {params});
  }

  getTaxon(territoryCode: string, nameCode: number) {
    const urlPath = `territories/${territoryCode}/taxons/${nameCode}`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.get<any>(url);
  }

  getTaxonInfos(territoryCode: string, nameCode: number, params = {}) {
    const urlPath = `territories/${territoryCode}/taxons/${nameCode}`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.get<any>(url, {params});
  }

  addAssessment(territoryCode: string, nameCode: number, assessmentData: any): Observable<any> {
    const urlPath = `territories/${territoryCode}/taxons/${nameCode}/assessments`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.post<any>(url, assessmentData);
  }

  updateAssessment(territoryCode: string, nameCode: number, data: any): Observable<any> {
    const urlPath = `territories/${territoryCode}/taxons/${nameCode}/assessments/${data.assessment.id}`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.put<any>(url, data);
  }

  getOrganisms(): Observable<IOrganism[]> {
    const url = `${this.cfg.getModuleBackendUrl()}/organisms`;
    return this.http.get<any>(url);
  }

  getAssessments(params: {} = {}) {
    const territory = this.store.selectedTerritory.code.toLowerCase();
    const taxon = this.store.selectedTaxon;
    const urlPath = `territories/${territory}/taxons/${taxon}/assessments`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.get<any>(url, {params});
  }

  getAssessment(assessmentId: number, params: {} = {}) {
    const territory = this.store.selectedTerritory.code.toLowerCase();
    const taxon = this.store.selectedTaxon;
    const urlPath = `territories/${territory}/taxons/${taxon}/assessments/${assessmentId}`;
    const url = `${this.cfg.getModuleBackendUrl()}/${urlPath}`;
    return this.http.get<any>(url, {params});
  }
}
