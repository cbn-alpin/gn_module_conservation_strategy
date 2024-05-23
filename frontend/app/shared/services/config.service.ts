import { Injectable } from '@angular/core';

import { ConfigService as GnConfigService } from '@geonature/services/config.service';

@Injectable()
export class ConfigService {

  constructor(
    public config: GnConfigService,
  ) {}

  getModuleTitle() {
    return this.config.CONSERVATION_STRATEGY.module_title;
  }

  getModuleCode() {
    return this.config.CONSERVATION_STRATEGY.module_code;
  }

  getAppUrl() {
    return `${this.config.URL_APPLICATION}`;
  }

  getBackendUrl() {
    return `${this.config.API_ENDPOINT}`;
  }

  getModuleBackendUrl() {
    return `${this.config.API_ENDPOINT}/${this.config.CONSERVATION_STRATEGY.module_code.toLowerCase()}`;
  }

  getFrontendModuleUrl() {
    return this.config.CONSERVATION_STRATEGY.module_code.toLowerCase();
  }

  getTaxHubBackendUrl() {
    return `${this.config.API_TAXHUB}`;
  }

  getTaxHubFrontendUrl() {
    return `${this.config.API_TAXHUB}`.replace('/api', '/');
  }

  getPriorityFloraBackendUrl() {
    return `${this.config.API_ENDPOINT}/${this.config.CONSERVATION_STRATEGY.module_code_pf.toLowerCase()}`;
  }
}
