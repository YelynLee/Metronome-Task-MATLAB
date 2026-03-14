# Metronome-Task-MATLAB
Post-research after the following paper [Keeping time and rhythm by internal simulation of sensory stimuli and behavioral actions](https://www.science.org/doi/full/10.1126/sciadv.adh8185)


## 1. Project Overview
- Objective: <br>Designing data acquisition and parameter management systems of metronome task for understanding temporal representation
- Key Points:
    - **Behavioral Task Modeling**: <br>Adapted the primate task into a human task with similar logic
    - **Parameter Management**: <br>Separated static and dynamic environment variables for scalable control
    - **Data Schema**: <br>Consistent subject data structure for integrity and integration
    - **Metadata**: <br>Recorded timestamps and code versions for data reproducibility


## 2. System Requirements
- OS: Tested on Windows
- Language: MATLAB R2024b
- Dependencies: Psychtoolbox


## 3. Installation Guide
1. Clone the repository
```bash
   git clone https://github.com/YelynLee/Metronome-Task-MATLAB.git
``` 
2. Open MATLAB and navigate to the project folder
3. Add the project folders to your MATLAB path:
```bash
   addpath(genpath(pwd));
   savepath;
``` 


## 4. Instructions for Use

### Directory Structure
```
Metronome_Human
|--code
|   |--run_metronome_experiment.m
|   |--load_config.m
|   |--init_psychtoolbox.m
|   |--start_screen.m
|   |--thank_you_screen.m
|   |--graceful_exit.m
|   |--data
|   |   |--sub_0001.mat
|   |   |--...
|   |--helpers
|       |--run_questionnaire.m
|       |--break_screen.m
|       |--get_subject_info.m
|       |--initialize_subject_struct.m
|       |--run_practice.m
|       |--run_main_blocks.m
|       |--run_trial.m
|       |--draw_fixation.m
|       |--draw_visual_dot.m
|       |--draw_click_pad.m
|       |--play_beep.m
|       |--highlight_choice.m
|       |--give_feedback.m
|       |--collect_response.m
|       |--save_full_data.m
|--analysis
    |--bar_bias.m
    |--bar_bias_interval_4cond.m
    |--bar_demographic.m
    |--easyweber_4cond.m
    |--easyweber_4cond_interval.m
    |--easyweber_all.m
    |--generalweber_4cond.m
    |--generalweber_all.m
    |--...
```


### Execution Example
1. To start the experiment, run the main script in the MATLAB Command Window:
```bash
run_metronome_experiment
```
2. Type in the subject ID number that you'll allocate to this experiment:
```bash
Subject ID (e.g., 0001): 0001
```
3. Select whether to skip the practice session or not:
```bash
[New] Created subject 0015
연습 세션을 건너뛰시겠습니까? (Y/N): Y
```


## 5. Results
- Experiment Description: <br>This project investigated how different sensory cues—Visual (V), Audio (A), and Motor (M)—contribute to maintaining an internal rhythm (metronome task). Subjects were asked to synchronize with a rhythm and then maintain it internally after the cues disappeared.
- Sensory Conditions:
    - V (Visual): Maintaining rhythm using only a visual circle
    - VA (Visual + Audio): Using both visual and auditory (sound) cues
    - VM (Visual + Motor): Using both visual and motor (clickpad) cues
    - VAM (Visual + Audio + Motor): Using all sensory cues


- H1: Multisensory vs. Single Sensory Performance
    - **Hypothesis**: <br>Performance will be higher in multisensory conditions (VA, VM, VAM) compared to visual-only (V), with VA (Audio-included) being the most effective.
    - **Result**: <br>Confirmed. The VA condition recorded the highest accuracy (0.875) and the lowest bias (0.0486).
- H2: Performance Stability Across Task Difficulty
    - **Hypothesis**: <br>Multisensory conditions will outperform the visual-only condition regardless of task difficulty (rhythm intervals of 0.5s vs. 1.0s).
    - **Result**: <br>Confirmed. The superiority of the VA condition remained consistent across different time intervals.
- H3: Precision and Noise Analysis (Weber Fraction)
    - **Weber Fraction (WF)**: <br>We found negative slopes across all conditions, meaning subjects' precision actually improved as the task duration increased (longer time led to more stable performance, which is inconsistent with the original results).
        - VA condition showed the most stable slope (-0.19), meaning it is least affected by increasing difficulty.
        - VM condition showed the steepest improvement (-0.984), suggesting that motor feedback helps subjects correct their bias significantly over time.
    - **Generalized Weber Fraction (GWF)**: <br>The analysis showed a slope of 0.0019, suggesting that most timing errors originate from a constant internal noise rather than scaling linearly with time. In short, the internalization of rhythm in this task is relatively independent of time-scaled variance (again, inconsistent with the original results).
- H4: Impact of Auditory Expertise
    - **Hypothesis**: <br>Subjects with prior auditory training will show significantly better performance.
    - **Result**: <br>Partially Confirmed. Trained subjects (Demographic score $\ge$ 9) showed slightly higher accuracy (0.80) and lower bias (0.19) compared to the untrained group (Accuracy: 0.79, Bias: 0.21). While the improvement was present, the difference was marginal, suggesting that the task is intuitive even for non-experts.


- Limitations:
    - **Narrow Task Range**: <br>The interval difference between the fastest and slowest trials was not large enough. This led to a lack of statistical significance in the Generalized Weber Fraction analysis.
    - **Oversimplified Demographics**: <br>The 5-question survey was too brief to accurately categorize "musically trained" individuals.
    - **Control Issues in Motor Condition**:
        - Subjects reported "habitual clicking" or unconscious cues (like humming or foot-tapping) even when the motor condition was not required.
        - Due to hardware constraints, real-time click detection was not implemented, meaning we could not verify if subjects followed the motor instructions perfectly.
        - Auditory noise from clicking might not have been fully isolated because we didn't use headsets for blocking outer noises.