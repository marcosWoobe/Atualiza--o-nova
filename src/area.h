////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This code did is maded by Tony Araújo (OrochiElf)
////////////////////////////////////////////////////////////////////////
#ifndef __AREA__
#define __AREA__
class Area
{
	public:
		Area(const std::list<uint32_t>& list, uint32_t _rows)
		{
			uint16_t x = 0, y = 0;
			centerX = centerY = 0;
			rows = _rows;
			cols = list.size() / _rows;

			data_ = new bool*[rows];
			for(uint32_t row = 0; row < rows; ++row)
				data_[row] = new bool[cols];

			for(std::list<uint32_t>::const_iterator it = list.begin(); it != list.end(); ++it)
			{
				data_[y][x] = false;

				if(*it == 1 || *it == 3)
					data_[y][x] = true;

				if(*it == 2 || *it == 3)
					centerX = x, centerY = y;

				x++;
				if(x == cols)
				{
					x = 0;
					y++;
				}
			}
		}

		virtual ~Area()
		{
			for(uint32_t row = 0; row < rows; ++row)
				delete[] data_[row];

			delete[] data_;
		}

		bool getValue(uint32_t row, uint32_t col) const {return data_[row][col];}
		std::list<Tile*> getList(const Position& pos);

		uint16_t getCenterX() const {return centerX;}
		uint16_t getCenterY() const {return centerY;}

		size_t getRows() const {return rows;}
		size_t getCols() const {return cols;}

	protected:
		uint16_t centerX, centerY;
		uint32_t rows, cols;
		bool** data_;
};
#endif
