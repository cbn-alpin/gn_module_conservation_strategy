/**
 * Join values of an array by the given string.
 * Usage: {{ myArray | join:', ' }}
 *
 * Licance: MIT
 * Source: https://github.com/fknop/angular-pipes/blob/master/src/array/join.pipe.ts
 */
import { Pipe, PipeTransform, NgModule } from '@angular/core';

@Pipe({
  name: 'join',
})
export class JoinPipe implements PipeTransform {

  transform(input: any, character: string = ''): any {
    if (!Array.isArray(input)) {
      return input;
    }

    return input.join(character);
  }
}

@NgModule({
  declarations: [JoinPipe],
  exports: [JoinPipe],
})
export class NgJoinPipeModule {}
