/**
 * Return an array of property value from an array of objects.
 * Usage: {{ myArrayOfObject | pluck:'myObjectPropertyName' }}
 *
 * Licance: MIT
 * Source: https://github.com/fknop/angular-pipes/blob/master/src/array/join.pipe.ts
 */
import { Pipe, PipeTransform, NgModule } from '@angular/core';

@Pipe({
  name: 'pluck',
})
export class PluckPipe implements PipeTransform {

  transform(input: any, key: string): any {
    if (!Array.isArray(input) || !key) {
      return input;
    }

    return input.map((value: any) => {
      return value !== null && typeof value === 'object' && value.hasOwnProperty(key)
        ? value[key]
        : undefined;
    });
  }
}

@NgModule({
  declarations: [PluckPipe],
  exports: [PluckPipe],
})
export class NgPluckPipeModule {}
