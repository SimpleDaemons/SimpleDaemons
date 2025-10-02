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
#include <chrono>
#include <thread>
#include <iomanip>

namespace simple_dummy {

DummyApp::DummyApp() {
    std::cout << "DummyApp initialized" << std::endl;
}

DummyApp::~DummyApp() {
    stop();
}

void DummyApp::run_daemon() {
    running_ = true;
    worker_thread_ = std::thread(&DummyApp::worker_loop, this);
    
    log_message("DummyApp daemon started");
    
    // Keep main thread alive
    while (running_) {
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
}

void DummyApp::run_foreground() {
    running_ = true;
    log_message("DummyApp running in foreground");
    
    // Run for 5 seconds then exit
    for (int i = 0; i < 5 && running_; ++i) {
        log_message("Foreground iteration " + std::to_string(i + 1));
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    
    running_ = false;
    log_message("DummyApp foreground mode completed");
}

void DummyApp::stop() {
    if (running_) {
        running_ = false;
        if (worker_thread_.joinable()) {
            worker_thread_.join();
        }
        log_message("DummyApp stopped");
    }
}

void DummyApp::worker_loop() {
    int counter = 0;
    while (running_) {
        log_message("Daemon worker iteration " + std::to_string(++counter));
        std::this_thread::sleep_for(std::chrono::seconds(2));
    }
}

void DummyApp::log_message(const std::string& message) {
    auto now = std::chrono::system_clock::now();
    auto time_t = std::chrono::system_clock::to_time_t(now);
    
    std::cout << "[" << std::put_time(std::localtime(&time_t), "%Y-%m-%d %H:%M:%S") << "] " 
              << message << std::endl;
}

} // namespace simple_dummy
