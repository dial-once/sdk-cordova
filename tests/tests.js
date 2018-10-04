/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

/* eslint-env jasmine */

exports.defineAutoTests = function () {
    describe('DialOnce API available', function () {
        it('API defined', function () {
            expect(navigator.dialonce).toBeDefined();
        });
        it('API init defined', function () {
            expect(navigator.dialonce.init).toBeDefined();
        });
        it('API setDebug defined', function () {
            expect(navigator.dialonce.setDebug).toBeDefined();
        });
        it('API requestPermissions defined', function () {
            expect(navigator.dialonce.requestPermissions).toBeDefined();
        });
        it('API setEnableCallInterception defined', function () {
            expect(navigator.dialonce.setEnableCallInterception).toBeDefined();
        });
        it('API isCallInterceptionEnabled defined', function () {
            expect(navigator.dialonce.isCallInterceptionEnabled).toBeDefined();
        });
    });

    describe('DialOnce.setDebug', function () {
        it('No exception', function () {
            expect(() => navigator.dialonce.setDebug(false)).not.toThrow();
            expect(() => navigator.dialonce.setDebug(true)).not.toThrow();
        });
    });

    describe('DialOnce.init', function () {
        it('No API Key', function () {
            expect(() => navigator.dialonce.init(null)).not.toThrow(new Error());
            // Error will be logged in logcat
        });

        it('DisplayInterstitial is optional', function () {
            expect(() => navigator.dialonce.init("SOME-APIKEY")).not.toThrow(new Error());
        });

        it('With DisplayInterstitial arg', function () {
            expect(() => navigator.dialonce.init("SOME-APIKEY", true)).not.toThrow(new Error());
        });
    });

    describe('DialOnce.setEnableCallInterception', function () {
        it('Stateful', function () {
            navigator.dialonce.setEnableCallInterception(false);
            expect(navigator.dialonce.isCallInterceptionEnabled).toBe(false);
            navigator.dialonce.setEnableCallInterception(true);
            expect(navigator.dialonce.isCallInterceptionEnabled).toBe(true);
        });
    });

};