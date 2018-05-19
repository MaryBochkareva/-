#include <iostream>
#include <vector>

class Labyrinth {
private:
	int H, W;
	std::vector<std::vector<bool>> used;
public:
	Labyrinth(int H, int W) :
		H(H),
		W(W),
		used(std::vector<std::vector<bool>>(H, std::vector<bool>(W)))
	{
		char sym;
		for (int i = 0; i < H; ++i) {
			for (int j = 0; j < W; ++j) {
				std::cin >> sym;
				if (sym == '#') {
					used[i][j] = true;
				}
				else {
					used[i][j] = false;
				}
			}
		}
	}

	int CountDeadEnds(int x_start, int y_start) {
		used[x_start][y_start] = true;
		int count = 0;
		bool f = false;
		if (x_start + 1 < H) {
			if (!used[x_start + 1][y_start]) {
				count += CountDeadEnds(x_start + 1, y_start);
				f = true;
			}
		}
		if (y_start + 1 < W) {
			if (!used[x_start][y_start + 1]) {
				count += CountDeadEnds(x_start, y_start + 1);
				f = true;
			}
		}
		if (x_start - 1 >= 0) {
			if (!used[x_start - 1][y_start]) {
				count += CountDeadEnds(x_start - 1, y_start);
				f = true;
			}
		}
		if (y_start - 1 >= 0) {
			if (!used[x_start][y_start - 1]) {
				count += CountDeadEnds(x_start, y_start - 1);
				f = true;
			}
		}
		if (!f) {
			count = 1;
		}
		return count;
	}
};

int main(int argc, char* argv[])
{
	int N;
	std::cin >> N;
	int H, W;
	for (int i = 0; i < N; ++i) {
		std::cin >> H >> W;
		Labyrinth l = Labyrinth(H, W);
		std::cout << "Case #" << i + 1 << ": " << l.CountDeadEnds(0, 1) << std::endl;
	}
	return 0;
}
