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
	public class ZoneData
	{
		private var _alignmentCoordinate:Number = 0;
		private var _range:Number = 0;
		
		public function get alignmentCoordinate():Number
		{
			return _alignmentCoordinate;
		}
		
		public function set alignmentCoordinate(value:Number):void
		{
			_alignmentCoordinate = value;
		}
		
		public function get range():Number
		{
			return _range;
		}
		
		public function set range(value:Number):void
		{
			_range = value;
		}
	}
}