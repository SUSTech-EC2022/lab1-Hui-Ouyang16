#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <algorithm>
#include <fstream>
#include <cmath>
#include <vector>
#include <time.h>
#include "Utils.h"
#include "MyStruct.h"

using namespace std;

#ifdef _WIN32
#include <hash_map>
#else
#include <unordered_map>
using namespace std;
#define hash_map unordered_map
#endif

#ifdef _WIN32
#include <direct.h>
#else
#include <sys/stat.h>
#endif

#ifdef _WIN32
#define MKDIR(a) _mkdir((a))
#else
#define MKDIR(a) mkdir((a),0777)
#endif

#define PRINT_RSLT 1

char inputPath[100] = "./instances";
char tspFiles[10][100] =
{
  "wi29",
  "dj38",
  "qa194",
  };

// Setting by default
int timeBudget = 30; // time budget in seconds
int beginIdx = 0;
int endIdx = 0;
int nbTrials = 1;
char resPath[100] = "./res";

double evaluation(TSP tsp, int *path){
    double cost = 0;
    for(int i=0; i<tsp.nbVertices-1; ++i){
        cost += sqrt(pow(tsp.vertices[*(path+i)].x - tsp.vertices[*(path+i+1)].x, 2) + pow(tsp.vertices[*(path+i)].y - tsp.vertices[*(path+i+1)].y, 2));
    }
    cost += sqrt(pow(tsp.vertices[*(path+tsp.nbVertices-1)].x - tsp.vertices[*(path)].x, 2) + pow(tsp.vertices[*(path+tsp.nbVertices-1)].y - tsp.vertices[*(path)].y, 2));
    return cost;
}

// ref: https://www.geeksforgeeks.org/keep-track-of-previous-indexes-after-sorting-a-vector-in-c-stl/
vector<pair<double, int> > sortArr(double arr[], int n)
{
    vector<pair<double, int> > vp;

    for (int i = 0; i < n; ++i) {
        vp.push_back(make_pair(arr[i], i));
    }

    sort(vp.begin(), vp.end());
  
    return vp;
}

int main(int argc, char* argv[])
{
    // Read arguments
    string _argValue;
    if(Utils::getStrArgValue(argc, argv, "timeBudget", _argValue))
    {
        timeBudget = stoi(_argValue);
    }
    if(Utils::getStrArgValue(argc, argv, "begin_index", _argValue))
    {   
        beginIdx = stoi(_argValue);
    }
    if(Utils::getStrArgValue(argc, argv, "end_index", _argValue))
    {   
        endIdx = stoi(_argValue);
    }
    if(Utils::getStrArgValue(argc, argv, "run_times", _argValue))
    {   
        nbTrials = stoi(_argValue);
    }
    if(Utils::getStrArgValue(argc, argv, "res_path", _argValue))
    {   
        strcpy(resPath, _argValue.c_str());
    }

    for (int inst = beginIdx; inst <= endIdx; inst++)//for each instance
    {
        char filename[100];
        strcpy(filename, inputPath);
        strcat(filename, "/");
        strcat(filename, tspFiles[inst]);
        strcat(filename, ".tsp");
        
        strcat(resPath, "/");
        MKDIR(resPath);
        strcat(resPath, tspFiles[inst]);
        strcat(resPath, "/");
        #ifdef PRINT_RSLT
        cout << "Input filename is " << filename << endl;
        cout << "Output results folder is " << resPath << endl;
        #endif

        // Read input instances
        fstream fin;
        fin.open(filename, ios::in|ios::binary);
        if (!fin)
        {
            cout << "Can't open file " << filename  << endl;
            exit(0);
        }
        TSP tsp;
        char dummyString[200];
        int dummyInt;
        double dummyDouble[2];
        fin.getline(dummyString, 200);
        int lineNum = 0;
        while(!fin.eof())
        {
            fin >> dummyString;
            if (strcmp(dummyString, "DIMENSION")==0)
            {
                fin >> dummyString;
                fin >> tsp.nbVertices;
            } 
            else if (strcmp(dummyString, "NODE_COORD_SECTION")==0)
            {
                tsp.vertices = new Vertice[tsp.nbVertices];
                for (int i=0; i<tsp.nbVertices; i++)
                {
                    fin.getline(dummyString, 100);
                    fin >> dummyString;
                    fin >> tsp.vertices[i].x;
                    fin >> tsp.vertices[i].y;
                }
            }
            else
            {
                continue;
            }
        }
        fin.close();
        #ifdef PRINT_RSLT
        cout << "Input instance: " << tspFiles[inst] << " of " << tsp.nbVertices << "cities, coordinates are:" << endl;
        for (int i=0; i<=tsp.nbVertices; i++)
        {
                cout << tsp.vertices[i].x << " " << tsp.vertices[i].y << endl;
        }
        #endif
        #ifdef PRINT_RSLT
        cout << "solving instance: " << tspFiles[inst] << endl;
        #endif

        int genCounter;
        double totalTime;
        double duration;
        double avgGenTime;
        clock_t beginTime;
        for (int r = 1; r <= nbTrials; r++)
        {
            totalTime = 0;
            duration = 0;
            avgGenTime = 0;
            beginTime = clock();

            // init the population and eval
            Individual *population = new Individual[10];
            for(int i=0; i<10; ++i){
                for(int j=0; j<tsp.nbVertices; ++j){
                    population[i].path[j] = j;
                }
                random_shuffle(&population[i].path[0], &population[i].path[tsp.nbVertices-1]);
                population[i].cost = evaluation(tsp, population[i].path);
            }

            for (int iter = 0; /*iter < MAXITERATIONS*/; iter++)
            {
                // reverse mutation but no combination
                Individual *springs = new Individual[10];
                double *costList = new double[20];
                for(int i=0; i<10; ++i){
                    int pos1 = rand() % tsp.nbVertices;
                    int pos2 = rand() & tsp.nbVertices;
                    for(int j=0; j<tsp.nbVertices; ++j){
                        if(j == pos1){
                            springs[i].path[j] = population[i].path[pos2];
                        }else if(j == pos2)
                        {
                            springs[i].path[j] = population[i].path[pos1];
                        }else{
                            
                            springs[i].path[j] = population[i].path[j];
                        }
                    }
                    springs[i].cost = evaluation(tsp, springs[i].path);
                    costList[i] = population[i].cost;
                    costList[i+10] = springs[i].cost;
                } 

                // best left
                vector<pair<double, int> > vp = sortArr(costList, 20);
                Individual *new_population = new Individual[10];
                for(int i=19; i>=10; --i){
                    for(int j=0; j<tsp.nbVertices; ++j){
                        new_population[19-i].path[j] = new_population[vp[i].second].path[j];
                    }
                    new_population[19-i].cost = new_population[vp[i].second].cost;
                }
                population = new_population;

                // Timing
                clock_t currTime = clock();
                duration = (double)(currTime - beginTime) / (double) CLOCKS_PER_SEC;
                double avgGenTime = duration / (double) iter;
                if (duration>timeBudget || (timeBudget-duration)<avgGenTime)
                {
                    // time, iteration number, solution(s), fitness value(s), obj value(s)
                    cout << "time: " << duration << endl;
                    cout << "iteration number: " << iter << endl;
                    cout << "solutions: [";
                    for(int i=0; i<tsp.nbVertices; ++i){
                        cout << " (" << tsp.vertices[population[0].path[i]].x << "," << tsp.vertices[population[0].path[i]].y << ")";
                    }
                    cout << " ]" << endl;
                    cout << "fitness value: " << 0-population[0].cost << endl;
                    cout << "obj value: " << population[0].cost << endl;
                    totalTime += duration;
                    break;
                }
            }
        }

    }
    return 0;
}
       
