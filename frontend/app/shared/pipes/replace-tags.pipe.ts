/**
 * Very simple and not secure pipe to replace an HTML tag by an other.
 * From: first parameter an array of tag name to search.
 * To: second parameter an array of tag name used like replacements.
 * Usage:
 *  {{ myHtmlText | replaceTags:['h1', 'h2']:['h5', 'h6']}}
 *  ngFor="let c of arrayOfObjects | sortBy:'asc':'propertyName'"
 */
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'replaceTags'
})
export class ReplaceTagsPipe implements PipeTransform {

  transform(text: string, from: string[], to: string[]): string {
    console.log('In ReplaceTagsPipe')
    if (from.length > 0 && from.length == to.length) {
      console.log('Size ok')
      from.forEach((search, idx) => {
        let replace = to[idx];
        text = text.replace(new RegExp(`<(\/?)${search}[^>]*?>`, 'ig'), `<$1${replace}>`);
      });
    }
    return text;
  }
}
