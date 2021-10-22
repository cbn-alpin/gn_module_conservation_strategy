import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";

import { ConfigService } from "./config.service";

@Injectable()
export class DataService {
  constructor(private http: HttpClient, private cfg: ConfigService) {}

  getTerritories() {
    console.log("ICI")
    return this.http.get<any>(`${this.cfg.getModuleBackendUrl()}/territories`);
  }
}
