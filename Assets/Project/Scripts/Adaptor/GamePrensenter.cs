using Chargezuma.Domain.Usecase;
using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class GamePresenter : IDisposable
{
    IGameUsecase Usecase = default;
    CompositeDisposable Disposable = default;

    public GamePresenter(IGameUsecase usecase)
    {
        Usecase = usecase;
        Disposable = new CompositeDisposable();
    }

    void Initialize()
    {
        
    }

    public void Dispose()
    {
        Disposable.Dispose();
    }
}
