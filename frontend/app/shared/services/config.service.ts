import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { AppConfig } from '@geonature_config/app.config';
import { ModuleConfig } from '../../module.config';

@Injectable()
export class ConfigService {

  constructor(
    private http: HttpClient,
  ) {}

  getModuleTitle() {
    return ModuleConfig.module_title;
  }

  getModuleCode() {
    return ModuleConfig.module_code;
  }

  getAppUrl() {
    return `${AppConfig.URL_APPLICATION}`;
  }

  getBackendUrl() {
    return `${AppConfig.API_ENDPOINT}`;
  }

  getModuleBackendUrl() {
    return `${AppConfig.API_ENDPOINT}/${ModuleConfig.module_code.toLowerCase()}`;
  }

  getFrontendModuleUrl() {
    return ModuleConfig.module_code.toLowerCase();
  }

  getTaxHubBackendUrl() {
    return `${AppConfig.API_TAXHUB}`;
  }

  getTaxHubFrontendUrl() {
    return `${AppConfig.API_TAXHUB}`.replace('/api', '/');
  }

  getPriorityFloraBackendUrl() {
    return `${AppConfig.API_ENDPOINT}/${ModuleConfig.module_code_pf.toLowerCase()}`;
  }
}
