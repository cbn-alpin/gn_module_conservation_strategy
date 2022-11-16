export interface IOrganism {
  id: number;
  name: string;
  // TODO: use a type UUID like https://www.reddit.com/r/typescript/comments/bhvd3w/comment/elw7qay/?utm_source=share&utm_medium=web2x&context=3
  uuid: string;
  logoUrl?: string;
}

export interface IAction {
  uuid?: string;
  id: number;
  level: string;
  levelCode: string;
  type: string;
  typeCode: string;
  typeDefinition: string;
  progress: string;
  progressCode: string;
  planFor: number;
  startingDate: string; // TODO: use a better type
  implementationDate: string; // TODO: use a better type
  description: string;
  partners: IOrganism[]; // TODO: use UUID[] instead
}

export class Action implements Partial<IAction> {
  uuid: string = Math.random().toString(36).substring(2, 5);
  id: number;
  level: string;
  levelCode: string;
  type: string;
  typeCode: string;
  typeDefinition: string;
  progress: string;
  progressCode: string;
  planFor: number;
  startingDate: string;
  implementationDate: string;
  description: string;
  partners: IOrganism[] = [];
}

export interface IAssessment {
  id: number;
  territoryCode: string;
  taxonNameCode: number;
  threats: string;
  description: string;
  assessmentDate: string;
  nextAssessmentYear: number;
  dateMin: string;// TODO: use a better type
  dateMax: string;// TODO: use a better type
  actions: Partial<IAction>[]|null;
  computedData: {};
  metaCreateDate: string;
  metaCreateBy: string;
  metaUpdateDate: string;
  metaUpdateBy: string;
}

export class Assessment implements IAssessment {
  id: number;
  territoryCode: string;
  taxonNameCode: number;
  threats: string;
  description: string;
  assessmentDate: string = new Date().toISOString();
  nextAssessmentYear: number = ((new Date()).getFullYear() + 10);
  dateMin: string;// TODO: use a better type
  dateMax: string;// TODO: use a better type
  actions: Partial<IAction>[] = [];
  computedData: {};
  metaCreateDate: string;
  metaCreateBy: string;
  metaUpdateDate: string;
  metaUpdateBy: string;
}

export interface IAssessmentList {
  total_count: number;
  incomplete_results: boolean;
  items: Partial<Assessment>[];
}
