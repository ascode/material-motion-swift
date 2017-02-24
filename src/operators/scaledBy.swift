/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

extension MotionObservableConvertible where T == CGFloat {

  /**
   Emits the incoming value * amount.
   */
  public func scaled(by amount: CGFloat) -> MotionObservable<CGFloat> {
    return _map(Metadata("\(#function)", args: [amount])) {
      $0 * amount
    }
  }

  /**
   Emits the incoming value * amount.
   */
  public func scaled(by amount: MotionObservable<T>) -> MotionObservable<T> {
    var lastValue: CGFloat?
    var amountValue: CGFloat?
    return MotionObservable<T>(Metadata("\(#function)", args: [amount])) { observer in
      let checkAndEmit = {
        guard let amount = amountValue, let value = lastValue else { return }
        observer.next(value * amount)
      }
      let selfSubscription = self.subscribe({ value in
        lastValue = value
        checkAndEmit()
      })
      let amountSubscription = amount.subscribe({ amount in
        amountValue = amount
        checkAndEmit()
      })
      return {
        selfSubscription.unsubscribe()
        amountSubscription.unsubscribe()
      }
    }
  }
}
