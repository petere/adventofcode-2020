#include <fstream>
#include <iostream>

struct passport
{
        bool byr;
        bool iyr;
        bool eyr;
        bool hgt;
        bool hcl;
        bool ecl;
        bool pid;
        bool cid;	// optional
};

static bool
passport_valid(passport &p)
{
        return p.byr && p.iyr && p.eyr && p.hgt && p.hcl && p.ecl && p.pid;
}

static std::string
get_value(std::string &str, const char *prefix)
{
        std::size_t pos1 = str.find(std::string(prefix) + ":");

        if (pos1 == std::string::npos)
                return "";

        pos1 += std::string(prefix).length() + 1;

        std::size_t pos2 = str.find_first_of(' ', pos1);

        if (pos2 == std::string::npos)
                pos2 = str.length();

        return str.substr(pos1, (pos2 - pos1));
}

static const char digits[] = "0123456789";
static const char hexdigits[] = "0123456789abcdef";

int
main(int argc, char *argv[])
{
        std::ifstream f;

        f.open("input.txt", std::ifstream::in);

        int count_valid = 0;
        passport p = passport();
        char buf[100];
        while(f.getline(buf, sizeof buf))
        {
                std::string str = buf;
                std::string val;

                if ((val = get_value(str, "byr")).length())
                {
                        if (val.length() == 4 && val.find_first_not_of(digits) == std::string::npos)
                        {
                                int n = std::stoi(val);
                                if (n >= 1920 && n <= 2002)
                                        p.byr = true;
                        }
                }
                if ((val = get_value(str, "iyr")).length())
                {
                        if (val.length() == 4 && val.find_first_not_of(digits) == std::string::npos)
                        {
                                int n = std::stoi(val);
                                if (n >= 2010 && n <= 2020)
                                        p.iyr = true;
                        }
                }
                if ((val = get_value(str, "eyr")).length())
                {
                        if (val.length() == 4 && val.find_first_not_of(digits) == std::string::npos)
                        {
                                int n = std::stoi(val);
                                if (n >= 2020 && n <= 2030)
                                        p.eyr = true;
                        }
                }
                if ((val = get_value(str, "hgt")).length())
                {
                        std::size_t end = val.find_first_not_of(digits);
                        if (end != std::string::npos)
                        {
                                int n = std::stoi(val.substr(0, end));
                                if (val[end] == 'c' && val[end + 1] == 'm')
                                        p.hgt = (n >= 150 && n <= 193);
                                else if (val[end] == 'i' && val[end + 1] == 'n')
                                        p.hgt = (n >= 59 && n <= 76);
                        }
                }
                if ((val = get_value(str, "hcl")).length())
                {
                        p.hcl = (val[0] == '#' && val.find_first_not_of(hexdigits, 1) == std::string::npos);
                }
                if ((val = get_value(str, "ecl")).length())
                {
                        p.ecl = (val == "amb" || val == "blu" || val == "brn" || val == "gry"
                                || val == "grn" || val == "hzl" || val == "oth");
                }
                if ((val = get_value(str, "pid")).length())
                {
                        if (val.length() == 9 && val.find_first_not_of(digits) == std::string::npos)
                                p.pid = true;
                }
                if ((val = get_value(str, "cid")).length())
                {
                        p.cid = true;
                }

                if (str.empty())
                {
                        if (passport_valid(p))
                                count_valid++;
                        p = passport();
                        continue;
                }
        }
        // count the last one
        if (passport_valid(p))
                count_valid++;

        std::cout << count_valid << std::endl;

        return 0;
}
