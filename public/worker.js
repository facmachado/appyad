/* jshint esversion: 8 */

/**
 *  Copyright (c) 2020 Flavio Augusto (@facmachado)
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */


var self = this;

self.addEventListener('message', e => self.postMessage(JSON.stringify({
  volta: JSON.parse(e.data)
})), false);
