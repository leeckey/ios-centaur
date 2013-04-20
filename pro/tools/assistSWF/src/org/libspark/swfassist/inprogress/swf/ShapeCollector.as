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

package org.libspark.swfassist.inprogress.swf
{
	import org.libspark.swfassist.swf.tags.AbstractTagVisitor;
	import org.libspark.swfassist.swf.tags.DefineShape;
	import org.libspark.swfassist.swf.tags.DefineShape2;
	import org.libspark.swfassist.swf.tags.DefineShape3;
	import org.libspark.swfassist.swf.tags.DefineShape4;
	import org.libspark.swfassist.swf.tags.DefineFont;
	import org.libspark.swfassist.swf.tags.DefineFont2;
	import org.libspark.swfassist.swf.tags.DefineFont3;
	import org.libspark.swfassist.swf.structures.Shape;

	public class ShapeCollector extends AbstractTagVisitor
	{
		private var _shapes:Array = [];
		
		public function get shapes():Array
		{
			return _shapes.slice();
		}
		
		public override function visitDefineShape(tag:DefineShape):void
		{
			collectShape(tag.shapes);
		}
		
		public override function visitDefineShape2(tag:DefineShape2):void
		{
			collectShape(tag.shapes);
		}
		
		public override function visitDefineShape3(tag:DefineShape3):void
		{
			collectShape(tag.shapes);
		}
		
		public override function visitDefineShape4(tag:DefineShape4):void
		{
			collectShape(tag.shapes);
		}
		
		public override function visitDefineFont(tag:DefineFont):void
		{
			collectShapes(tag.glyphShapeTable);
		}
		
		public override function visitDefineFont2(tag:DefineFont2):void
		{
			collectShapes(tag.glyphShapeTable);
		}
		
		public override function visitDefineFont3(tag:DefineFont3):void
		{
			collectShapes(tag.glyphShapeTable);
		}
		
		private function collectShapes(shapes:Array):void
		{
			for each (var shape:Shape in shapes) {
				collectShape(shape);
			}
		}
		
		private function collectShape(shape:Shape):void
		{
			_shapes.push(shape);
		}
	}
}