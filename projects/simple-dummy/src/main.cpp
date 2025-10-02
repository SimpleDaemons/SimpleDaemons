/*
 * Copyright 2024 SimpleDaemons
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "simple_dummy/dummy_app.hpp"
#include <iostream>
#include <thread>
#include <chrono>

int main(int argc, char* argv[]) {
    std::cout << "Simple Dummy Application v0.1.0" << std::endl;
    std::cout << "A test application for build system standardization" << std::endl;
    
    simple_dummy::DummyApp app;
    
    if (argc > 1 && std::string(argv[1]) == "--daemon") {
        std::cout << "Running in daemon mode..." << std::endl;
        app.run_daemon();
    } else {
        std::cout << "Running in foreground mode..." << std::endl;
        app.run_foreground();
    }
    
    return 0;
}
