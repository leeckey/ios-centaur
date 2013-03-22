package centaur.data.buff
{
	public final class BuffData
	{
		public var buffType:int;
		public var skillID:uint;
		public var durationRound:int;
		
		public function BuffData(buffType:int, skillID:uint = 0, durationRound:int = 0)
		{
			this.buffType = buffType;
			this.skillID = 0;
			this.durationRound = durationRound;
		}
	}
}