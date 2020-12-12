using System;

public class Program
{
    public static void Main(string[] args)
    {
        System.IO.StreamReader file = new System.IO.StreamReader("input.txt");
        string line;

        // math coordinate grid
        int direction = 0;
        int pos_x = 0;
        int pos_y = 0;

        while((line = file.ReadLine()) != null)
        {
            char action = line[0];
            int arg = Convert.ToInt32(line.Substring(1));

            switch (action)
            {
                case 'N':
                    pos_y += arg;
                    break;
                case 'S':
                    pos_y -= arg;
                    break;
                case 'E':
                    pos_x += arg;
                    break;
                case 'W':
                    pos_x -= arg;
                    break;
                case 'L':
                    direction += arg;
                    if (direction >= 360)
                        direction -= 360;
                    break;
                case 'R':
                    direction -= arg;
                    if (direction < 0)
                        direction += 360;
                    break;
                case 'F':
                    pos_x += (int) (arg * Math.Cos(Math.PI * direction / 180.0));
                    pos_y += (int) (arg * Math.Sin(Math.PI * direction / 180.0));
                    break;
                default:
                    System.Console.Error.WriteLine("invalid action: {0}", action);
                    System.Environment.Exit(1);
                    break;
            }
        }
        file.Close();

        int mhd = Math.Abs(pos_x) + Math.Abs(pos_y);
        System.Console.WriteLine(mhd);

        // part 2

        file = new System.IO.StreamReader("input.txt");

        int wp_x = 10;
        int wp_y = 1;

        pos_x = 0;
        pos_y = 0;

        while((line = file.ReadLine()) != null)
        {
            char action = line[0];
            int arg = Convert.ToInt32(line.Substring(1));

            switch (action)
            {
                case 'N':
                    wp_y += arg;
                    break;
                case 'S':
                    wp_y -= arg;
                    break;
                case 'E':
                    wp_x += arg;
                    break;
                case 'W':
                    wp_x -= arg;
                    break;
                case 'L':
                case 'R':
                    double angle = (Math.PI * arg) / 180;
                    if (action == 'R')
                        angle = -angle;
                    double x = wp_x * Math.Cos(angle) - wp_y * Math.Sin(angle);
                    double y = wp_x * Math.Sin(angle) + wp_y * Math.Cos(angle);
                    wp_x = Convert.ToInt32(x);
                    wp_y = Convert.ToInt32(y);
                    break;
                case 'F':
                    pos_x += wp_x * arg;
                    pos_y += wp_y * arg;
                    break;
                default:
                    System.Console.Error.WriteLine("invalid action: {0}", action);
                    System.Environment.Exit(1);
                    break;
            }
        }
        file.Close();

        mhd = Math.Abs(pos_x) + Math.Abs(pos_y);
        System.Console.WriteLine(mhd);
    }
}
