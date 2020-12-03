import java.io.BufferedReader;
import java.io.FileReader;
import java.util.*;

public class Program {
    public static void main(String[] args) throws Exception {
        List<boolean[]> trees = new ArrayList<boolean[]>();
        int line_length = 0;

        try (BufferedReader br = new BufferedReader(new FileReader(args[0]))) {
            String line;
            while ((line = br.readLine()) != null) {
                line_length = line.length();
                boolean[] treeline = new boolean[line.length()];
                for (int i = 0; i < line.length(); i++) {
                    char c = line.charAt(i);
                    if (c == '.')
                        treeline[i] = false;
                    else if (c == '#')
                        treeline[i] = true;
                    else
                        throw new Exception("wrong char");
                }
                trees.add(treeline);
            }
        }

        int current_row = 0;
        int current_col = 0;
        int count_trees = 0;

        while (current_row < trees.size()) {
            if (trees.get(current_row)[current_col % line_length])
                count_trees++;

            current_row += 1;
            current_col += 3;
        }

        System.out.println(count_trees);

        // part 2

        int[][] slopes = {
            {1, 1},
            {3, 1},
            {5, 1},
            {7, 1},
            {1, 2},
        };

        long product = 1;

        for (int[] slope : slopes) {
            current_row = 0;
            current_col = 0;
            count_trees = 0;

            while (current_row < trees.size()) {
                if (trees.get(current_row)[current_col % line_length])
                    count_trees++;

                current_row += slope[1];
                current_col += slope[0];
            }

            product *= count_trees;
        }

        System.out.println(product);
    }
}
