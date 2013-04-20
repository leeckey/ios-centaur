/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.swf.structures
{
	public class RGBA extends RGB
	{
		private var _alpha:uint = 0xff;
		
		// UI8
		public function get alpha():uint
		{
			return _alpha;
		}
		
		public function set alpha(value:uint):void
		{
			_alpha = value;
		}
		
		public override function fromUint(color:uint):void
		{
			alpha = (color >> 24) & 0xff;
			red = (color >> 16) & 0xff;
			green = (color >> 8) & 0xff;
			blue = color & 0xff;
		}
		
		public override function toUint():uint
		{
			return ((alpha & 0xff) << 24) | ((red & 0xff) << 16) | ((green & 0xff) << 8) | (blue & 0xff);
		}
	}
}