//
//  MockFileConversionUseCase.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//
import Entities
import UseCasesProtocols
import Combine

class MockFileConversionUseCase: FileConversionUseCaseProtocol {
    var progressPublisher: PassthroughSubject<Entities.ConversionFileModel, Never>
    
    var enqueueFileCalled = false
    var cancelTaskCalled = false
    
    init(progressPublisher: PassthroughSubject<Entities.ConversionFileModel, Never>, enqueueFileCalled: Bool = false, cancelTaskCalled: Bool = false) {
        self.progressPublisher = progressPublisher
        self.enqueueFileCalled = enqueueFileCalled
        self.cancelTaskCalled = cancelTaskCalled
    }
    func enqueueFile(_ file: ConversionFileModel) {
        enqueueFileCalled = true
    }
    
    func cancelTask(for model: ConversionFileIDs) {
        cancelTaskCalled = true
    }
}
