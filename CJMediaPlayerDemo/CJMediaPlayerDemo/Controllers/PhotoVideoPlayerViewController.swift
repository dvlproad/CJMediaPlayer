//
//  PhotoVideoPlayerViewController.swift
//  CJMediaPlayerDemo
//
//  Created by qian on 2025/3/8.
//  Copyright © 2025 dvlproad. All rights reserved.
//

import UIKit
import AVKit
import PhotosUI

@available(iOS 14.0, *)
@objc class PhotoVideoPlayerViewController: UIViewController, PHPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 添加按钮，执行 selectVideo
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = .red
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.setTitle("选择视频", for: .normal)
        button.addTarget(self, action: #selector(trySelectVideo(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        // 配置音频会话
        configureAudioSession()
    }
    
    /// 配置音频会话，解决从相册中选择的视频播放没有声音的问题
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("配置音频会话失败: \(error.localizedDescription)")
        }
    }

    @IBAction func trySelectVideo(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                print("已授权访问相册")
                DispatchQueue.main.async {
                    self?.selectVideo()
                }
                
            case .denied, .restricted, .notDetermined:
                print("未授权访问相册")
            case .limited:
                print("访问相册受限")
            @unknown default:
                break
            }
        }
    }
    
    func selectVideo() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard let result = results.first else { return }

        result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error) in
            if let error = error {
                print("加载视频失败: \(error.localizedDescription)")
                return
            }
            if let sourceURL = url {
                // 将视频文件复制到沙盒目录，抽取为方法后，播放异常了？？？
//                DispatchQueue.main.async {
//                    if let destinationURL = self.copyVideoToSandbox(from: sourceURL) {
//                        self.playVideo(url: destinationURL)
//                    } else {
//                        print("复制视频文件失败")
//                    }
//                }
                let fileManager = FileManager.default
                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationURL = documentsDirectory.appendingPathComponent(sourceURL.lastPathComponent)

                do {
                    if fileManager.fileExists(atPath: destinationURL.path) {
                        try fileManager.removeItem(at: destinationURL)
                    }
                    try fileManager.copyItem(at: sourceURL, to: destinationURL)

                    DispatchQueue.main.async {
                        self.playVideo(url: destinationURL)
                    }
                } catch {
                    print("复制视频文件失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 将视频文件复制到沙盒目录
    /// - Parameter sourceURL: 原始视频文件的 URL
    /// - Returns: 复制成功返回沙盒目录中的 URL，失败返回 nil
    func copyVideoToSandbox(from sourceURL: URL) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(sourceURL.lastPathComponent)

        do {
            // 如果目标文件已存在，先删除
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            // 复制文件
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            print("视频文件已复制到沙盒目录: \(destinationURL)")
            return destinationURL
        } catch {
            print("复制视频文件失败: \(error.localizedDescription)")
            return nil
        }
    }

    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}
